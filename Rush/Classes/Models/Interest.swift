//
//  Interest.swift
//  Interest
//
//  Created by kamal on 28/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit

class Interest: Codable {
    
    var interestId: Int64 = 0
    var interestName: String = ""
    var eventList: [Event]?
    
    init(data: [String: Any]) {
        setValue(data: data)
    }
    
    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case interestId = "interest_id"
        case interestName = "name"
//         case eventList = "event"
    }
    
    // MARK: - Private Functions
    private func setValue(data: [String: Any]) {
        
        if let value = data[Keys.interestId] as? Int64 {
            interestId = value
        }
        
        if let value = data[Keys.interestName] as? String {
            interestName = value
        }
    }
}
