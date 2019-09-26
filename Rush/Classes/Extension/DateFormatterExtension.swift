//
//  DateFormatterExtension.swift
//  Rush
//
//  Created by kamal on 26/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import Foundation
extension DateFormatter {
  
    static let serverDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
