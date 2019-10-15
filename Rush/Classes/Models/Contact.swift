//
//  ContactsItem.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

class Contact: NSObject {
    var id: String = ""
    var displayName: String = ""
    var origin: String = ""
    var phone: String = ""
    var email: String = ""
    var birthday: Date?
    var avatarBaseString: String = ""
    var contactImage: UIImage?

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
