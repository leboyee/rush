//
//  HomeServices.swift
//  Rush
//
//  Created by ideveloper on 22/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ServiceManager {
    
    // MARK: - Home
      
    func fetchHomeList(params: [String: Any], closer: @escaping (_ params: Home?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getHomeList(params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processHomeModelResponse(result: data, error: error, code: code, closer: {(list, errorMessage) in
                closer(list, errorMessage)
            })
           
        }
    }
    
    // MARK: - Club
         
    func createClub(params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.createClub(params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func updateClub(clubId: String, params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.updateClub(clubId: clubId, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func fetchClubList(sortBy: String, params: [String: Any], closer: @escaping (_ params: [Club]?, _ total: Int, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClubList(sortBy: sortBy, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.procesModelResponse(result: data, error: error, code: code, closer: { (clubs, total, errorMessage) in
                closer(clubs, total, errorMessage)
            })
        }
    }
    
    func fetchClubDetail(clubId: String, params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClubDetail(clubId: clubId, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func joinClub(clubId: String, params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.joinClub(clubId: clubId, param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func deleteClub(clubId: Int64, params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.deleteClub(clubId: clubId, param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func fetchClubInviteeList(clubId: String, params: [String: Any], closer: @escaping (_ list: [Invitee]?, _ count: Int, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClubInviteeList(clubId: clubId, params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (invitees, total, errorMessage) in
                closer(invitees, total, errorMessage)
            })
        }
    }
    func fetchClassGroupRostersList(classId: String, groupId: String, params: [String: Any], closer: @escaping (_ list: [ClassJoined]?, _ count: Int, _ errorMessage: String?) -> Void) {
           NetworkManager.shared.getClassGroupRostersList(classId: classId, groupId: groupId, params: params) { [weak self] (data, error, code) in
               guard let unsafe = self else { return }
               guard code != NetworkManager.localNetworkStatusCode else { return }
               unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (invitees, total, errorMessage) in
                   closer(invitees, total, errorMessage)
               })
           }
       }
    
    func joinClassGroup(classId: String, groupId: String, params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.joinClassGroup(classId: classId, groupId: groupId, param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func getClassDetail(classId: String, groupId: String, params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getClassDetail(classId: classId, groupId: groupId, param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func createEvent(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.createEvent(params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func fetchMemberIds(dataType: String, dataId: String, params: [String: Any], closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getMemberIds(dataType: dataType, dataId: dataId, param: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            guard code != NetworkManager.localNetworkStatusCode else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
}
