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
    var imageJson: String?
    var numberOfLikes: Int = 0
    var numberOfUnLikes: Int = 0
    var numberOfComments: Int = 0
    var user: User?
    var createDate: Date?

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case parentId = "data_id"
        case text = "desc"
        case imageJson = "photos"
        case numberOfLikes = "up_votes"
        case numberOfUnLikes = "down_votes"
        case numberOfComments = "total_comments"
        case user
        case createDate
    }
    
    init() {
    }
}
