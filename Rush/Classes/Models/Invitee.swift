//
//  Invitee.swift
//  Rush
//
//  Created by ideveloper on 30/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Invitee: Codable {

    var id: String = ""
    var user: User?
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
    }
    
    init() {
        // default empty init
    }
    
    init(name: String) {
        id = UUID().uuidString
        self.user = User()
        self.user?.firstName = name
    }
}
