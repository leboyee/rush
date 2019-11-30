//
//  NotificationService.swift
//  Rush
//
//  Created by kamal on 03/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
extension ServiceManager {

    /*
     Fetch Notification List
     Params
     profileUserId: logged in user id
     pageNo: 1 or more
     */
    func fetchNotificationList(params: [String: Any], closer: @escaping (_ list: [NotificationItem]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getNotificationList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (list, _, errorMessage) in
                closer(list, errorMessage)
            })
        }
    }
    
    /*
     *
     */
    // MARK: - Get Badge Count
    func getBadgeCount(closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.unreadNotificationCount { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    /*
     *
     */
    // MARK: - Update Badge Count
    func updateBadgeCount(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.updateUnreadNotificationCount(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
}
