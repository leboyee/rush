//
//  ChatServices.swift
//  Rush
//
//  Created by ideveloper on 21/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ServiceManager {
    
    /*
     Fetch Restaurant List
     Params
     profileUserId: logged in user id
     pageNo: 1 or more
     search: friend name which we want to search
     */
    func fetchFriendsList(params: [String: Any], closer: @escaping (_ params: [Friend]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getFriendList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (friends, errorMessage) in
                closer(friends, errorMessage)
            })
        }
    }
}
