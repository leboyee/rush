//
//  Invite.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

class Invite: NSObject {
    var contact: Contact?
    var profile: User?
    var isFriend: Bool = false

    init(data: [String: Any]) {
        super.init()
        setData(data: data)
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - Private Functions
    func setData(data: [String: Any]) {
        
    }
}
