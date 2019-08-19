//
//  Image.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//


import UIKit

class Image: NSObject {

    lazy var id       : String = ""
    lazy var main     : String = ""
    lazy var thumb    : String = ""
    var localImage    : UIImage?
    
    var url : URL? {
        guard main.count > 0 else { return nil }
        return URL(string : main)
    }
    
    var urlThumb : URL? {
        guard thumb.count > 0 else { return nil }
        return URL(string : thumb)
    }
    
    init(data : [String : Any]) {
        super.init()
        setData(data: data)
    }
    
    init(json : String) {
        super.init()
        setData(jsonString: json)
    }
    
    override init() {
        super.init()
    }
    
    // TODO: - Development Function
    init(url: String) {
        super.init()
        main = url
        thumb = url
    }
    
    func setData(data : [String : Any]) {
        if let values = data[Keys.main] as? [String: Any], let url = values[Keys.url] as? String {
            main = url
        }
        
        if let values = data[Keys.thumb] as? [String: Any], let url = values[Keys.url] as? String {
            thumb = url
        }
    }
    
    func setData(jsonString : String) {
        if let data = jsonString.data(using: .utf8) {
            do {
                if let object = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [[String : Any]]
                {
                    if let first = object.first {
                         setData(data: first)
                    }
                } else {
                    print("Error in json : " + jsonString)
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
}
