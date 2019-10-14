//
//  Notifications.swift
//  Rush
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import Foundation

extension Notification.Name {

    //ResetPasswordReceivedNotification
    static let badAccess = Notification.Name("kBadAccessReceivedNotification")
    static let badNetwork = Notification.Name("kBadNetworkConnectivity")
    static let resetPassword = Notification.Name("kResetPasswordReceivedNotification")
    static let underMaintenance = Notification.Name("kUnderMaintenance")
}
