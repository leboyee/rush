//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Comment: Codable {

    var id: Int64?
    var userId: Int64?
    var parentId: Int64? // Event / Club / Class
    var desc: String?
    var postId: Int64?
    var totalThreadCount: Int = 0
    var user: User?
    var threadComment: [Comment]?
    var mentionedUser: [MentionedUser]?
    var createDate: String?
    var mentionedUserIds: [String]?

    private enum CodingKeys: String, CodingKey {
        case id = "cmt_id"
        case userId = "user_id"
        case parentId = "parent_id"
        case desc = "cmt_desc"
        case postId = "post_id"
        case totalThreadCount = "total_thread_count"
        case user
        case createDate = "created_at"
        case threadComment = "thread_comment"
        case mentionedUser = "mentioned_users"
        case mentionedUserIds = "mentioned_user_ids"
    }
    
    init() {
    }
}
