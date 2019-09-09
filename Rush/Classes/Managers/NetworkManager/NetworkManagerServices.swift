//
//  NetworkManagerServices.swift
//  eventX_ios
//
//  Created by Kamal Mittal on 22/04/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
extension NetworkManager {

    // MARK: - Autherization API's
    func checkEmail(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "email/check", params: params, resultHandler: resultHandler)
    }
    
    func login(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/login", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func signup(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/signup", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func connectWithFB(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/social/login", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func logout(resultHandler: @escaping ResultClosure) {
        requestDelete(path: "auth/logout", params: [:], resultHandler: resultHandler)
    }

    func phonetkn(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/phonetkn", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func authPhone(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/phone", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func resendSMS(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "phone/verify", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    // MARK: - Profile
    func updateProfile(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "profile", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func uploadUserProfileImage(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "profile/photo", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }

    func instagramConnect(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "instagram/connect", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func getProfile(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "profile", params: params, resultHandler: resultHandler)
    }

    // MARK: - Update Token
    func updatePushToken(params: [String: String], resultHandler: @escaping ResultClosure) {
        requestPost(path: "pushtoken", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    // MARK: - Major and Minor list
    func getMajorList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "major", params: params, resultHandler: resultHandler)
    }
    
    func getMinorList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "minor", params: params, resultHandler: resultHandler)
    }
    
    func getInterestList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "interest", params: params, resultHandler: resultHandler)
    }

    func getFriendList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "friend", params: params, resultHandler: resultHandler)
    }
    
    func createClub(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "club", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }
   
    func getClubList(sortBy: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "club/\(sortBy)/list", params: params, resultHandler: resultHandler)
    }
    
    func getClubDetail(clubId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "club/\(clubId)", params: params, resultHandler: resultHandler)
    }
    
    func createPost(param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "post", params: param, contentType: ContentType.formData, resultHandler: resultHandler)
    }
    
    func postComment(param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "comment", params: param, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func votePost(postId: String, voteType: String, resultHandler: @escaping ResultClosure) {
        requestPut(path: "post/\(postId)/vote/\(voteType)", params: [:], contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func fetchPostList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "club", params: params, resultHandler: resultHandler)
    }
}
