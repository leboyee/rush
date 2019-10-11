//
//  Tag.swift
//  Rush
//
//  Created by kamal on 16/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Tag: Codable {

    var id: Int64
    var text: String
    
    init(id: Int64, text: String) {
        self.id = id
        self.text = text
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "interest_id"
        case text = "name"
    }
}
