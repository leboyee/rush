//
//  Post.swift
//  Rush
//
//  Created by kamal on 11/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Post: Codable {

    var id: String?
    var parentId: String? // Event / Club / Class
    var text: String?
    var images: [Image]?
    var numberOfLikes: Int = 0
    var numberOfComments: Int = 0
    var user: User?
    var createDate: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case parentId
        case text
        case images
        case numberOfLikes
        case numberOfComments
        case user
        case createDate
    }

    init() {
    }
    
    // Added below function for user objects
    public func encode(to encoder: Encoder) throws {
    }
}
