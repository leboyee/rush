//
//  Profile.swift
//  Rush
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

//class category e.g Technologies
class Class: Codable {
    private var classId: Int64 = 0
    var classList: [SubClass]?
    var name: String = ""
    
    init() { }
    
    private enum CodingKeys: String, CodingKey {
        case classId = "class_cat_id"
        case name
        case classList = "classes"
    }
    var id: String {
        return String(classId)
    }
}

//actual class e.g Fine Arts
class SubClass: Codable {
    
    private var classId: Int64 = 0
    var location: String = ""
    var name: String = ""
    var photo: String = ""
    private var classCatId: Int64 = 0
    var classTotalGroups: Int64 = 0
    
    var classGroups: [ClassGroup]?
    init() { }
    
    private enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case name = "class_name"
        case location = "class_location"
        case photo = "class_photo"
        case classCatId = "class_cat_id"
        case classTotalGroups = "class_total_groups"
        case classGroups = "class_groups"
    }
    var id: String {
        return String(classId)
    }
    var categoryId: String {
        return String(classCatId)
    }
    
}

//class group e.g 110-A
class ClassGroup: Codable {

    private var classGroupId: Int64 = 0
    private var classIdP: Int64 = 0
    var name: String = ""
    var totalRosters: Int = 0
    var myJoinedGroup: [String]?
    
    init() { }

    private enum CodingKeys: String, CodingKey {
        case classGroupId = "class_grp_id"
        case classIdP = "class_id"
        case name = "name"
        case totalRosters = "total_rosters"
        case myJoinedGroup = "my_joined_group"
        
    }
    var id: String {
        return String(classGroupId)
    }
    var classId: String {
        return String(classIdP)
    }
}
