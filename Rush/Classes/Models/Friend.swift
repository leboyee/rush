//
//  Friend.swift
//  Friends
//
//  Created by kamal on 28/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit

enum FriendStatus {
    case none
    case requestSent
    case requestPending
    case approved
}

class Friend: Codable {
    
    var friendId: String = "0"
    var friendUserId: String = "0"
    var friendOtherUserId: String = "0"
    var friendStatus: Int = 0
    var friendType: Int = 0
    var user: User?
    
    var friendName: String {
        if let list = user?.name.components(separatedBy: " ") as [String]?, list.count >= 2 {
            if let first = list.first, let second = list.last, !first.isEmpty, !second.isEmpty {
                let indexToOfText = second.index(second.startIndex, offsetBy: 1)
                let text = first + " " + second[..<indexToOfText]
                return text
            }
        }
        return user?.name ?? ""
    }
    
    init() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case friendId = "_id"
        case friendUserId = "frd_user_id"
        case friendOtherUserId = "frd_other_user_id"
        case friendType = "frd_type"
        case friendStatus = "frd_status"
        case user
    }
}

