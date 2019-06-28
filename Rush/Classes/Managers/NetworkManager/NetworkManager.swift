//
//  NetworkManager.swift
//  eventX_ios
//
//  Created by Kamal Mittal on 22/04/18.
//  Copyright © 2018 -. All rights reserved.
//
import UIKit
import SystemConfiguration

enum ContentType: String {
    case none = ""
    case formData = "multipart/form-data"
    case formUrlencoded = "application/x-www-form-urlencoded"
    case applicationJson = "application/json"
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}

typealias ResultClosure = (_ success: Any?,
    _ failure: Error?,
    _ statuscode: Int) -> (Void)

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    let errorDomain = "com.messapps.rush"
    static var userAgent : String!

    var xAPIKey: String  {
        get {
            return Bundle.main.infoDictionary!["APIKey"] as! String
        }
    }
    
    var urlSession: URLSession {
        get {
            if (urlSession_ == nil) {
                self.sessionConfigurator.timeoutIntervalForRequest = 60.0
                self.sessionConfigurator.timeoutIntervalForResource = 60.0
                self.sessionConfigurator.httpMaximumConnectionsPerHost = 5
                self.operationQueue.maxConcurrentOperationCount = 15
                urlSession_ = URLSession.init(configuration: self.sessionConfigurator,
                                              delegate: nil,
                                              delegateQueue: self.operationQueue)
            }
            return urlSession_!
        }
    }
    
    var baseUrl: URL {
        get {
            var serverAddress = ""
            var path = ""
            serverAddress = Bundle.main.infoDictionary?["ServerAddress"] as? String ?? ""
            path = Bundle.main.infoDictionary?["APIPath"] as? String ?? ""
            return URL(string: (serverAddress + path))!
        }
    }
    
    
    
    private var urlSession_: URLSession?
    private let sessionConfigurator = URLSessionConfiguration.default
    private let operationQueue = OperationQueue()
    private var networkRequestNumber = 0
    
    var defaultHeaders: [String: String] {
        get {
            
            var dict = [String:String]()
            dict["Accept"] = "application/json"
            dict["User-Agent"] = NetworkManager.getUserAgent()
            
            let defaults = UserDefaults.standard
            var deviceId = defaults.string(forKey: kDeviceId)
            
            if deviceId == nil {
                deviceId = UIDevice.current.identifierForVendor?.uuidString
                deviceId = deviceId?.replacingOccurrences(of: "-", with: "")
                defaults.set(deviceId, forKey: kDeviceId)
            }
            
            if deviceId != nil {
                dict["X-Device-ID"] = deviceId!
            }
            
            dict["X-API-Key"] = xAPIKey
            //if Authorization.shared.authorized {
            //    dict["X-Session-ID"] = Authorization.shared.session!
            //}
            
            if let pushToken = Utils.getDataFromUserDefault(kPushToken) {
                dict["X-Push-Token"] = pushToken as? String
            }
            
            dict["X-Device-Type"] = "ios"
            if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
               dict["X-App-Version"] = "\(version)"
            }

            //Set time offset
            let timezoneoffset = NSTimeZone.system.secondsFromGMT()
            dict[kTimezoneOffset] = String(timezoneoffset)
            
            return dict
        }
    }
    
    //MARK: Private
    func requestDelete(path: String,
                       params: Any,
                       resultHandler: @escaping ResultClosure) {
        
        makeNetworkActivityHidden(false)
        let requestType = RequestType.delete
        let requestDelete = self.request(with: requestType,
                                         contentType: ContentType.none,
                                         path: path,
                                         params: params)
        
        let dataTask = self.requestDataTask(request: requestDelete, requestType: requestType, resultHandler: resultHandler)
        dataTask?.resume()
    }
    
    func requestGet(path: String,
                    params: Any,
                    resultHandler: @escaping ResultClosure) {
        self.getRequestGet(path: path, params: params, resultHandler: resultHandler)?.resume()
    }
    
    func getRequestGet(path: String,
                       params: Any,
                       resultHandler: @escaping ResultClosure) -> URLSessionDataTask? {
        
        
        makeNetworkActivityHidden(false)
        
        let requestType = RequestType.get
        let requestGet = self.request(with: requestType,
                                      contentType: ContentType.none,
                                      path: path,
                                      params: params)
        
        let dataTask = self.requestDataTask(request: requestGet, requestType: requestType, resultHandler: resultHandler)
        dataTask?.resume()
        return dataTask
    }
    
    func requestPost(path: String,
                     params: Any,
                     contentType: ContentType,
                     resultHandler: @escaping ResultClosure) {
        
        makeNetworkActivityHidden(false)
        
        let requestType = RequestType.post
        let requestPost = self.request(with: requestType,
                                       contentType: contentType,
                                       path: path,
                                       params: params)
        let task = self.requestDataTask(request: requestPost, requestType: requestType, resultHandler: resultHandler)
        task?.resume()
    }
    
    func requestPut(path: String,
                     params: Any,
                     contentType: ContentType,
                     resultHandler: @escaping ResultClosure) {
        
        makeNetworkActivityHidden(false)
        
        let requestType = RequestType.put
        let requestPost = self.request(with: requestType,
                                       contentType: contentType,
                                       path: path,
                                       params: params)
        let task = self.requestDataTask(request: requestPost, requestType: requestType, resultHandler: resultHandler)
        task?.resume()
    }
    
    func requestUploadImage(path: String,
                            params: [String : Any],
                            contentType: ContentType,
                            resultHandler: @escaping ResultClosure) {
        
        makeNetworkActivityHidden(false)
        let requestType = RequestType.post
        let requestPost = self.requestUpload(with: contentType, path: path, params: params)
        let task = self.requestDataTask(request: requestPost, requestType: requestType, resultHandler: resultHandler)
        
        task?.resume()
        
    }
    
    
    func requestDataTask(request: URLRequest,
                         requestType: RequestType,
                         resultHandler: @escaping ResultClosure) -> URLSessionDataTask? {
        
        if !isNetworkAvailable {
            NotificationCenter.default.post(name: NSNotification.Name.badNetwork, object: nil)
            return nil
        }
        
        let task = urlSession.dataTask(with: request) {
            [weak self]
            (data, response, error) in
            
            
            var resultSuccess: Any? = nil
            var resultError: Error? = nil
            var resultStatusCode: Int = 0
            
            
            #if targetEnvironment(simulator)
                if data != nil {
                    let jsonString = String(data: data!, encoding: String.Encoding.utf8)
                    print(jsonString!)
                }
            #endif
            
            defer {
                DispatchQueue.main.async {
                    self?.makeNetworkActivityHidden(true)
                    resultHandler(resultSuccess, resultError, resultStatusCode)
                }
            }
            
            guard let self_ = self else { return }
            
            guard error == nil else {
                resultError = error
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            resultStatusCode = httpResponse.statusCode
            
            
            guard resultStatusCode != 404 else {
                return
            }
            
            guard resultStatusCode != 401 else {
                NotificationCenter.default.post(name: Notification.Name.badAccess, object: nil)
                let response = self_.makeResponseFromServer(data: data, httpResponse: httpResponse, methodName: requestType.rawValue)
                resultSuccess = response
                resultError = self_.makeError(code: resultStatusCode, description: "Restricted access")
                return
            }
            
            let headers = httpResponse.allHeaderFields
            guard let contentTypeHeader = headers["Content-Type"] as? String else {
                resultError = self_.makeError(code: 0, description: "The content-type is not setted")
                return
            }
            
            
            guard contentTypeHeader.contains("application/json") || contentTypeHeader.contains("json") else {
                resultError = self_.makeError(code: 0, description: "The content-type is not correct. Must be application/json but was \(contentTypeHeader)")
                //print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))
                return
            }
            
            guard let dataResponse = self?.makeResponseFromServer(data: data, httpResponse: httpResponse, methodName: requestType.rawValue) else {
                resultError = self_.makeError(code: 0, description: "response is nil")
                return
            }
            
            if dataResponse is Error {
                resultError = dataResponse as? Error
                return
            }
            
            if let dataResponse = dataResponse as? [String: Any] {
                resultSuccess = dataResponse
            } else if let dataResponse = dataResponse as? [[String: Any]] {
                resultSuccess = dataResponse
            } else {
                resultError = self_.makeError(code: 0, description: "Unexpected error")
                return
            }
        }
        
        return task
    }
    
    func request(with method: RequestType, contentType: ContentType, path: String, params: Any?) -> URLRequest {
        var url : URL!
        if (path.isEmpty) {
            //Gift card api
            url = URL(string: "")
        }
        else {
            url = URL(string: path, relativeTo: self.baseUrl)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = (path.isEmpty) ? [:] : defaultHeaders
        request.url = url
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        
        
        if method == .get || method == .head {
            request.httpShouldUsePipelining = true
        }
        
        guard let parameters = params else {
            return request
        }
        
        
        guard (method == .get || method == .head || method == .delete) == false else {
            
            let range = path.range(of: "?")
            var appendingString = ""
            let serializedParams = self.serilizeParams(parameters as! Dictionary<String, Any>)
            if range == nil {
                appendingString = "?\(serializedParams)"
            } else {
                appendingString = "&\(serializedParams)"
            }
            let newUrl = URL(string: url.absoluteString.appending(appendingString))
            request.url = newUrl
            
            return request
        }
        
        
        let charset = String(CFStringConvertEncodingToIANACharSetName(CFStringEncoding(String.Encoding.utf8.rawValue)))
        switch contentType {
        case ContentType.applicationJson:
            //For Node JS Server
            //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            //For Php
            request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        case ContentType.formData:
            let POSTBoundary = "paidmeals-boundary"
            request.setValue("multipart/form-data; charset=\(charset); boundary=\(POSTBoundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = self.buildMultipartFormData(postBody: POSTBoundary, params: parameters as! [[String : AnyObject]])
        case ContentType.formUrlencoded:
            request.setValue("application/x-www-form-urlencoded; charset=\(charset)", forHTTPHeaderField: "Content-Type")
            request.httpBody = self.serilizeParams(parameters as! Dictionary<String, Any>).data(using: String.Encoding.utf8)
        case ContentType.none:
            break
        }
        
        return request
    }
    
    
    func  requestUpload(with contentType: ContentType, path: String, params: [String : Any]?) -> URLRequest {
        
        let POSTBoundary = "friends-boundary"
        
        let charset = String(CFStringConvertEncodingToIANACharSetName(CFStringEncoding(String.Encoding.utf8.rawValue)))
        let url = URL(string: path, relativeTo: self.baseUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        request.allHTTPHeaderFields = defaultHeaders
        request.url = url
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.setValue("multipart/form-data; charset=\(charset); boundary=\(POSTBoundary)", forHTTPHeaderField: "Content-Type")
        
        
        guard params != nil else {
            return request
        }
        
        var body = Data()
        for (key, value) in params! {
            body.append("--\(POSTBoundary)\r\n".data(using: String.Encoding.utf8)!)
            if value is Data {
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\("file.jpg")\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \("image/jpg")\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(value as! Data)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }
            else
            {
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        body.append("--\(POSTBoundary)\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body
        return request
    }
    
    //MARK: private methods
    static func getUserAgent() -> String {
        if self.userAgent == nil {
            guard let application = Bundle.main.object(forInfoDictionaryKey: "CFBundleName"),
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
                else {
                    return ""
            }
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0,  count: size)
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            let machineString = String(cString: machine)
            let os = UIDevice.current.systemVersion
            userAgent = "\(application)/\(version) (iOS; \(machineString); \(os)"
            UserDefaults.standard.set(userAgent, forKey: "UserAgent")
        }
        return userAgent
    }
    
    //MARK: Helper methods
    
    func makeNetworkActivityHidden(_ hidden: Bool) {
        if hidden {
            self.networkRequestNumber -= 1
        }
        
        if self.networkRequestNumber <= 0 {
            self.networkRequestNumber = 0
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.networkRequestNumber += 1
        }
    }
    
    func makeError(code statusCode:Int, description: String) -> Error {
        let error = NSError(domain: errorDomain,
                            code: statusCode,
                            userInfo: [NSLocalizedDescriptionKey: description])
        return error as Error
    }
    
    func makeResponseFromServer(data: Data?,
                                httpResponse: HTTPURLResponse,
                                methodName: String) -> Any {
        
        var json: Any = [:]
        
        if let data_ = data {
            if let json_ = try? JSONSerialization.jsonObject(with: data_, options: .mutableContainers) {
                json = json_
                
            } else {
                let errorDescription = "error while trying to convert response from server to json in \(methodName) request"
                return makeError(code: 0, description: errorDescription)
            }
        }
        
        if (httpResponse.statusCode >= 500) {
            if let js = json as? [String : Any] {
                var errorDesctiption = ""
                if let errorJson = js["error"] as? String {
                    errorDesctiption = errorJson
                } else {
                    errorDesctiption = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                }
                return makeError(code: httpResponse.statusCode, description: errorDesctiption)
            }
        }
        
        return json
    }
    
    func buildMultipartFormData(postBody requestBodyBoundary: String,
                                params: [[String: AnyObject]]) -> Data {
        var mutableData = Data()
        mutableData.append("--\(requestBodyBoundary)\r\n".data(using: String.Encoding.utf8)!)
        var bodyParts = [Data]()
        for var value in params {
            var someData = Data()
            let name = value["name"]!
            let contentType = value["Content-Type"]!
            someData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: String.Encoding.utf8)!)
            someData.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
            
            
            if let dataValue = value["data"] {
                if dataValue is Dictionary<String, Any> {
                    someData.append(try! JSONSerialization.data(withJSONObject: dataValue, options: .prettyPrinted))
                }
                else {
                    if let newData = (dataValue as? String)?.data(using: String.Encoding.utf8)! {
                        someData.append(newData)
                    }
                }
            }
            
            bodyParts.append(someData)
        }
        
        var resultingData = Data()
        let count = bodyParts.count
        bodyParts.enumerated().forEach { (offset: Int, element: Data) in
            resultingData.append(element)
            if offset != count - 1 {
                resultingData.append("\r\n--\(requestBodyBoundary)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        mutableData.append(resultingData)
        mutableData.append("\r\n--\(requestBodyBoundary)--\r\n".data(using: String.Encoding.utf8)!)
        return mutableData
    }
    
    func arrayToNSData(array: [Any]) -> NSData {
        let data = NSMutableData()
        
        return data
    }
    
    func serilizeParams(_ params:Dictionary<String, Any>) -> String {
        
        var pairs = [String]()
        for key: String in params.keys {
            let value: Any = params[key] as Any
            if value is Dictionary <String, Any> {
                for subKey: String in (value as! Dictionary<String, Any>).keys {
                    pairs.append("\(key)[\(subKey)]=\(self.escapeValue(for:(value as! Dictionary<String, Any>)[subKey] as! String))")
                }
            } else if value is Array<String> {
                for subValue: String in (value as! Array<String>) {
                    pairs.append("\(key)[]=\(self.escapeValue(for:(value as! Dictionary<String, Any>)[subValue] as! String))")
                }
            } else {
                if value is NSNumber {
                    let valueToEscape: String = "\(value as! NSNumber)"
                    pairs.append("\(key)=\(self.escapeValue(for: valueToEscape))")
                } else {
                    pairs.append("\(key)=\(self.escapeValue(for: value as! String))")
                }
            }
        }
        return pairs.joined(separator: "&")
    }
    
    func escapeValue(for urlParameter: String) -> String {
        //NOTE (BY CHIRAG): I had removed + symbol, as it need to be convert in GET request (Specially in Forgot password)
        return urlParameter.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=$,/?%#[]"))!
    }
    
    func makeParamsForData(params: Dictionary<String, Any>) -> Array<Dictionary<String, Any>> {
        var mutableParams = Array<Dictionary<String, Any>>()
        for key: String in params.keys {
            let metaInfo = ["name": key,
                            "Content-Type": "text/plain",
                            "data": params[key]]
            mutableParams.append(metaInfo as Any as! [String : Any])
        }
        return mutableParams
    }
}
