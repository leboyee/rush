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
    var images: [Image]?
    var numberOfLikes: Int = 0
    var numberOfUnLikes: Int = 0
    var numberOfComments: Int = 0
    var user: User?
    var createDate: Date?

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case parentId = "data_id"
        case text = "desc"
        case images = "photos"
        case numberOfLikes = "up_votes"
        case numberOfUnLikes = "down_votes"
        case numberOfComments = "total_comments"
        case user
        case createDate
    }

    init() {
    }
    
    /*
    // Added below function for user objects
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(images, forKey: .images)
        try container.encode(user, forKey: .user)
    }*/
}
