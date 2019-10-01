//
//  PostServices.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
extension ServiceManager {
    
    // MARK: - Post
    func createPost(params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.createPost(param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
 
    func deletePost(postId: String, params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.deletePost(postId: postId, param: params) { [weak self] (data, error, code) in
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
    
    func fetchCommentList(postId: String, closer: @escaping (_ comments: [Comment]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getCommentList(postId: postId, param: [:]) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.procesModelResponse(result: data, error: error, code: code, closer: { (comments, errorMessage) in
                closer(comments, errorMessage)
            })
        }
    }
    
    func votePost(postId: String, voteType: String, closer: @escaping (_ post: Post?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.votePost(postId: postId, voteType: voteType) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                if let object = data?[Keys.post] as? [String: Any] {
                    let post: Post? = uwself.decodeObject(fromData: object)
                    closer(post, nil)
                } else {
                    closer(nil, errorMessage)
                }
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
    
    func fetchClubCategoryList(params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClubCategoryList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func fetchCategoryClassList(params: [String: Any], closer: @escaping (_ params: [Class]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getCategoryClassList(params: params) { [weak self] (classList, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: classList, error: error, code: code, closer: { (classList, errorMessage) in
                closer(classList, errorMessage)
            })
        }
    }
}
