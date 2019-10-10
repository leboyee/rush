//
//  Invitee.swift
//  Rush
//
//  Created by ideveloper on 30/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Invitee: Codable {

    private var inviteeId: Int64 = 0
    var user: User?
    
    private enum CodingKeys: String, CodingKey {
        case inviteeId = "club_invite_id"
        case user
    }
    
    var id: String {
        return String(inviteeId)
    }
    
    init() {
        // default empty init
    }
}
