//
//  HomeServices.swift
//  Rush
//
//  Created by ideveloper on 22/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ServiceManager {
    
    // MARK: - Club
    func createClub(params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.createClub(params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func fetchClubList(sortBy: String, params: [String: Any], closer: @escaping (_ params: [Club]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClubList(sortBy: sortBy, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.procesModelResponse(result: data, error: error, code: code, closer: { (clubs, errorMessage) in
                closer(clubs, errorMessage)
            })
        }
    }
    
    func fetchClubDetail(clubId: String, params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClubDetail(clubId: clubId, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func joinClub(clubId: String, params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.joinClub(clubId: clubId, param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    // MARK: - Post
    func createPost(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.createPost(param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func createEvent(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.createEvent(params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func postComment(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.postComment(param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
        
    func votePost(postId: String, voteType: String, closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.votePost(postId: postId, voteType: voteType) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func getPostList(dataId: String, type: String, params: [String: Any], closer: @escaping (_ params: [Post]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.fetchPostList(dataId: dataId, type: type, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.procesModelResponse(result: data, error: error, code: code, closer: { (posts, errorMessage) in
                 closer(posts, errorMessage)
            })
        }
    }

}
