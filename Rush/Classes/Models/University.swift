//
//  University.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class University: Codable {
    
    var universtiyId: Int64 = 0
    var universityName: String = ""
    var universityLogo: String?
    var streetAddress: String?
    var addressLocality: String?
    var addressRegion: String?
    var postalCode: String?
    var addressCountry: String?
    var location: String?
    var mainUrl: String?
    
    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case universtiyId = "university_id"
        case universityName = "name"
        case universityLogo = "logo"
        case streetAddress = "street_address"
        case addressLocality = "address_locality"
        case addressRegion = "address_region"
        case postalCode = "postal_code"
        case addressCountry = "address_country"
        case location = "location"

    }
    
    var logo: String? {
       if let newlogo = universityLogo {
            setData(jsonString: newlogo)
       }
       return mainUrl
    }

    func setData(jsonString: String) {
        if let data = jsonString.data(using: .utf8) {
            do {
                if let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    if let url = object[Keys.url] as? String {
                        mainUrl = url
                    }
                } else {
                    //print("Error in json : " + jsonString)
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }

}
