//
//  Profile.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//


import UIKit

class Classes: NSObject {

    var id: Int = 0
    var category: String = ""
    var subClasses = [SubClasses]()
    
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

class SubClasses: NSObject {
    
    var id: Int = 0
    var category: String = ""
    var name: String = ""

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
