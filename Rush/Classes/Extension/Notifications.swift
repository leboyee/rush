//
//  Notifications.swift
//  Rush
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import Foundation

extension Notification.Name {

    //ResetPasswordReceivedNotification
    static let badAccess = Notification.Name("kBadAccessReceivedNotification")
    static let badAccessAlert = Notification.Name("kBadAccessReceivedNotificationAlert")
    static let badNetwork = Notification.Name("kBadNetworkConnectivity")
    static let resetPassword = Notification.Name("kResetPasswordReceivedNotification")
    static let underMaintenance = Notification.Name("kUnderMaintenance")
    static let userProfile = Notification.Name("kUserProfile")
}
