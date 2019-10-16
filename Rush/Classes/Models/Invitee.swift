//
//  Invitee.swift
//  Rush
//
//  Created by ideveloper on 30/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Invitee: Codable {

    var user: User?
    var rsvpAns: [RSVPAnswer]?

    private enum CodingKeys: String, CodingKey {
        //case inviteeId = "invite_id"
        case user
        case rsvpAns = "rsvp_ans"
    }
    
    init() {
        // default empty init
    }
}
