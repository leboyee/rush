//
//  Invitees.swift
//  Rush
//
//  Created by ideveloper on 30/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Invitees: Decodable {

    var id: String = ""
    var user: User?
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
    }
    
    init() {
        // default empty init
    }
    
    required init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
        user = (try? container?.decode(User.self, forKey: .user))
    }
}
