//
//  HomeServices.swift
//  Rush
//
//  Created by ideveloper on 22/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ServiceManager {
    
    func createClub(params : [String : Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.createClub(params: params) {
            [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func fetchClubList(sortBy: String, params: [String : Any], closer: @escaping (_ params: [String : Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClubList(sortBy: sortBy, params: params) {
            [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
}
