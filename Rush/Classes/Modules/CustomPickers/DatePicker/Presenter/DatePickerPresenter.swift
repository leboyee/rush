//
//  DatePickerPresenter.swift
//  wolf
//
//  Created by Kamal Mittal on 16/07/18.
//  Copyright © 2018 Suresh Jagnani. All rights reserved.
//

import UIKit

class DatePickerPresenter: NSObject {
    // MARK: - Defines handler and varibales
    var type: UIDatePicker.Mode = .date
    var title: String = ""
    var minDate: Date?
    var maxDate: Date?
    var currentDate: Date?

    var updateTitle: ((_ title: String) -> Void)?
    var updatePickerMode: ((_ type: UIDatePicker.Mode) -> Void)?
    var updateMinDate: ((_ date: Date) -> Void)?
    var updateMaxDate: ((_ date: Date) -> Void)?
    var updateCurrentDate: ((_ date: Date) -> Void)?

    // MARK: - Life Cycle
    deinit {
        
    }
    
    // MARK: - View Output Functions
    func viewIsReady() {
        updateTitle?(title)
        updatePickerMode?(type)
        if let min = minDate {
            updateMinDate?(min)
        }
        
        if let max = maxDate {
            updateMaxDate?(max)
        }
        
        if let current = currentDate {
            updateCurrentDate?(current)
        }
    }
}

extension DatePickerPresenter {
    
}
