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
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (list, errorMessage) in
                closer(list, errorMessage)
            })
        }
    }
}
