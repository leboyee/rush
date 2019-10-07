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

class Class: Codable {
    var id: String = ""
    var classList: [SubClass]?
    var name: String = ""
    
    init() { }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case classList = "classes"
    }
}

class SubClass: Codable {
    
    var id: String = ""
    var location: String = ""
    var name: String = ""
    var photo: String = ""
    var categoryId: String = ""
    var classTotalGroups: Int = 0
    
    var classGroups: [ClassGroup]?
    init() { }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "class_name"
        case location = "class_location"
        case photo = "class_photo"
        case categoryId = "class_cat_id"
        case classTotalGroups = "class_total_groups"
        case classGroups = "class_groups"
    }
}

class ClassGroup: Codable {

    var id: String = ""
    var classId: String = ""
    var name: String = ""
    var totalRosters: Int = 0
    var myJoinedGroup: [String]?
    
    init() { }

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case classId = "class_id"
        case name = "name"
        case totalRosters = "total_rosters"
        case myJoinedGroup = "my_joined_group"
        
    }
}
