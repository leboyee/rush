//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct PostVote: Codable {
    var id: String = ""
    var status: Int = -1
    var type: Int = 0 // 1 = up, -1 = down
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case type
    }
}

class Post: Codable {

    private var id: Int64 = 0
    var parentId: Int64? // Event / Club / Class
    var text: String?
    var totalUpVote: Int = 0
    var numberOfLikes: Int = 0
    var numberOfUnLikes: Int = 0
    var numberOfComments: Int = 0
    var user: User?
    var createDate: Date?
    var createdAt: String?
    var myVote: [PostVote]?

    private var imageJson: String?
    private var convertedListOfImages: [Image]?
    var images: [Image]? {
        if convertedListOfImages == nil {
            convertedListOfImages = imageJson?.photos
        }
        return convertedListOfImages
    }
    
    var postId: String {
        return String(id)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "post_id"
        case parentId = "data_id"
        case text = "post_desc"
        case imageJson = "photos"
        case totalUpVote = "total_votes"
        case numberOfLikes = "up_votes"
        case numberOfUnLikes = "down_votes"
        case numberOfComments = "total_comments"
        case user
        case createDate
        case createdAt = "created_at"
        case myVote = "my_post_vote"
    }
    
    init() {
        
    }
}
