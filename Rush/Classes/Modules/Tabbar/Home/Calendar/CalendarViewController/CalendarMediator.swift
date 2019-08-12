//
//  CalendarMediator.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CalendarViewController {

    func setupCalender() {
        calenderView.delegate = self
    }
    
}

extension CalendarViewController: CalendarViewDelegate {
    
    func isEventExist(date: Date) -> Bool {
        let allKeys = groups.map({ $0.dateString })
        if allKeys.contains(date.toString(format: "yyyy-MM-dd")) {
            return true
        }
        return false
    }
    
    func setHeightOfView(height: CGFloat) {
        calenderViewHeight.constant = height
        if isCalendarOpen {
            listTopConstraint.constant = topListPadding + calenderViewHeight.constant
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func changeMonth(month: String, year: String) {
        print(month + " " + year)
    }
    
    func selectedDate(date: Date) {
        print(date)
    }
    
}
