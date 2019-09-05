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

class Friend: Profile {
    
    var friendId: Int64 = 0
    var friendUserId: String = "0"
    var friendOtherUserId: String = "0"
    var friendStatus: Int = 0
    var friendType: Int = 0
    
    var matchId: Int64 = 0
    var matchStatus: Int64 = 0
    
    override init(data: [String: Any]) {
        super.init(data: data)
        setValue(data: data)
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - Other functions
    var friendName: String {
        get {
            if let list = name.components(separatedBy: " ") as [String]?, list.count >= 2 {
                if let first = list.first, let second = list.last, !first.isEmpty, !second.isEmpty {
                    let indexToOfText = second.index(second.startIndex, offsetBy: 1)
                    let text = first + " " + second[..<indexToOfText]
                    return text
                }
            }
            return name
        }
    }
    
    // MARK: - Private Functions
    private func setValue(data: [String : Any]) {
        
        if let object = data[Keys.friend] as? [String: Any] {
            if let frdId = object[Keys.friendId] as? Int64 {
                friendId = frdId
            }
        }
        
        if let frdId = data[Keys.friendId] as? Int64 {
            friendId = frdId
        }
        
        if let value = data[Keys.friendUserId] as? Int64 {
            friendUserId = String(value)
        }
        
        if let value = data[Keys.friendOtherUserId] as? Int64 {
            friendOtherUserId = String(value)
        }
        
        if let value = data[Keys.friendStatus] as? Int {
            friendStatus = value
        }
        
        if let value = data[Keys.friendType] as? Int {
            friendType = value
        }
        
        // Match status
        if let value = data[Keys.matchStatus] as? Int64 {
            matchStatus = value
        }
        
        // Profile
        setData(data: data)
    }
    
}
