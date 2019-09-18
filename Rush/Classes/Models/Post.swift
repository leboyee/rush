//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Post: Codable {

    var id: String?
    var parentId: String? // Event / Club / Class
    var text: String?
    var desc: String?
    var images: [Image]?
    var numberOfLikes: Int = 0
    var numberOfUnLikes: Int = 0
    var numberOfComments: Int = 0
    var user: User?
    var createDate: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case parentId
        case text
        case images
        case numberOfLikes
        case numberOfUnLikes
        case numberOfComments
        case user
        case createDate
        case desc
    }

    init() {
    }
    
    // Added below function for user objects
    public func encode(to encoder: Encoder) throws {
    }
}
