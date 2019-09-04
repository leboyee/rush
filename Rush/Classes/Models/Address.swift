//
//  Address.swift
//  Rush
//
//  Created by kamal on 04/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Address: Codable {

    var addressline: String?
    var addressline2: String?
    var city: String?
    var state: String?
    var country: String?
    var zipcode: String?
    var latitude: Double?
    var longitude: Double?

    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case addressline
        case addressline2
        case city
        case state
        case country
        case zipcode
        case latitude
        case longitude
    }
}

extension Address {
    
}
