//
//  Image.swift
//  Rush
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class Image: Codable {

    var id: String = ""
    var main: String = ""
    var thumb: String = ""
    var medium: String = ""
    var large: String = ""
    var date: Date?

    init() {
    }
    
    init(data: [String: Any]) {
        setData(data: data)
    }
    
    init(json: String) {
        setData(jsonString: json)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case main
        case thumb
        case medium
        case large
    }
    
    // TODO: - Development Function
    init(url: String) {
        main = url
        thumb = url
    }
    
}

extension Image {
    
    func url() -> URL? {
        guard main.count > 0 else { return nil }
        return URL(string: main)
    }
    
    func urlThumb() -> URL? {
        guard thumb.count > 0 else { return nil }
        return URL(string: thumb)
    }
    
    func urlLarge() -> URL? {
        guard large.count > 0 else { return nil }
        return URL(string: large)
    }
    
    func urlMedium() -> URL? {
        guard medium.count > 0 else { return nil }
        return URL(string: medium)
    }
    
    func setData(data: [String: Any]) {
        if let values = data[Keys.main] as? [String: Any], let url = values[Keys.url] as? String {
            main = url
        }
        
        if let values = data[Keys.main] as? [String: Any], let dateStr = values[Keys.date] as? String {
            date = DateFormatter.serverDate.date(from: dateStr)
        }
        
        if let values = data[Keys.thumb] as? [String: Any], let url = values[Keys.url] as? String {
            thumb = url
        }
        
        if let values = data[Keys.medium] as? [String: Any], let url = values[Keys.url] as? String {
            medium = url
        }
        
        if let values = data[Keys.large] as? [String: Any], let url = values[Keys.url] as? String {
            large = url
        }
    }
    
    func setData(jsonString: String) {
        if let data = jsonString.data(using: .utf8) {
            do {
                if let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    setData(data: object)
                } else {
                    print("Error in json : " + jsonString)
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
