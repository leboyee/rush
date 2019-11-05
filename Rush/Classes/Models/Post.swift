//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct PostVote: Codable {
    var id: Int64 = 0
    var status: Int = -1
    var type: Int = 0 // 1 = up, -1 = down
    
    private enum CodingKeys: String, CodingKey {
        case id = "post_vote_id"
        case status
        case type
    }
}

class Post: Codable {

    private var id: Int64 = 0
    private var parentIdP: Int64 = 0 // Event / Club / Class

    var text: String?
    var userId: Int = 0
    var totalUpVote: Int = 0
    var numberOfLikes: Int = 0
    var numberOfUnLikes: Int = 0
    var numberOfComments: Int = 0
    var user: User?
    var createdAt: Date?
    var myVote: [PostVote]?
    var type: String = ""
    
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
        case parentIdP = "data_id"
        case userId = "user_id"
        case text = "post_desc"
        case imageJson = "photos"
        case totalUpVote = "total_votes"
        case numberOfLikes = "up_votes"
        case numberOfUnLikes = "down_votes"
        case numberOfComments = "total_comments"
        case user
        case createdAt = "created_at"
        case myVote = "my_post_vote"
        case type = "data_type"
    }
    
    var parentId: String {
        return String(parentIdP)
    }
    
    init() {
        
    }
}
