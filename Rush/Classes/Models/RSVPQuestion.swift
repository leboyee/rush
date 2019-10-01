//
//  RSVPQuestion.swift
//  Rush
//
//  Created by kamal on 01/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
class RSVPQuestion: Codable {
    var index: Int
    var que: String?
    
    private enum CodingKeys: String, CodingKey {
        case index
        case que
    }
}
