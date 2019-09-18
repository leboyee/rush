//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit



class Post: Decodable {

    var id: String = ""
    var userId: String = ""
    var dataId: String = ""
    var desc: String = ""
    var dataType: String = ""
    var photos: String = ""
    var totalComments: String = ""
    var totalVotes: String = ""
    var upVotes: String = ""
    var downVotes: String = ""
    var user: User?
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId = "user_id"
        case dataId = "data_id"
        case desc = "desc"
        case dataType = "data_type"
        case totalComments = "total_comments"
        case totalVotes = "total_votes"
        case upVotes = "up_votes"
        case downVotes = "down_votes"
        case photos = "photos"
        case user
    }
    
    init() {
        // default empty init
    }
    
    required init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
        userId = (try? container?.decode(String.self, forKey: .userId)) ?? ""
        dataId = (try? container?.decode(String.self, forKey: .dataId)) ?? ""
        dataType = (try? container?.decode(String.self, forKey: .dataType)) ?? ""
        totalComments = (try? container?.decode(String.self, forKey: .totalComments)) ?? ""
        totalVotes = (try? container?.decode(String.self, forKey: .totalVotes)) ?? ""
        upVotes = (try? container?.decode(String.self, forKey: .upVotes)) ?? ""
        downVotes = (try? container?.decode(String.self, forKey: .downVotes)) ?? ""
        desc = (try? container?.decode(String.self, forKey: .desc)) ?? ""
        photos = (try? container?.decode(String.self, forKey: .photos)) ?? ""
        user = (try? container?.decode(User.self, forKey: .user))
    }
}
