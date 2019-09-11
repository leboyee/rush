//
//  Post.swift
//  Rush
//
//  Created by kamal on 11/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Post: Codable {

    var id: Int64
    var parentId: Int64 // Event / Club / Class
    var text: String?
    var images: [Image]?
    var numberOfLikes: Int
    var numberOfComments: Int
    var user: User?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case parentId
        case text
        case images
        case numberOfLikes
        case numberOfComments
        case user
    }

    // Added below function for user objects
    public func encode(to encoder: Encoder) throws {
    }
}
