//
//  CalendarViewController.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
struct EventGroup {
    var dateString: String
    var events: [CalendarItem]
}

class CalendarViewController: CustomViewController {

    var selectedDate = Date()
    let titleHeight: CGFloat = 44
    let titleWidth: CGFloat = screenWidth - 110
    let topListPadding: CGFloat = 13.0

    var groups = [EventGroup]()
    var child: CalendarEventListViewController?
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calenderView: CalendarView!
    @IBOutlet weak var calenderViewHeight: NSLayoutConstraint!
    
    var dateButton: UIButton!
    var isCalendarOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

}

// MARK: - Setup
extension CalendarViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight))
        let text = selectedDate.toString(format: "MMMM dd") + " ▾"
        
        dateButton = UIButton(frame: CGRect(x: 0, y: 2, width: titleWidth, height: 30.0))
        dateButton.setTitle(text, for: .normal)
        dateButton.setTitleColor(UIColor.white, for: .normal)
        dateButton.titleLabel?.font = UIFont.displayBold(sz: 24)
        dateButton.contentHorizontalAlignment = .left
        dateButton.addTarget(self, action: #selector(viewCalenderButtonAction), for: .touchUpInside)
        customTitleView.addSubview(dateButton)
        navigationItem.titleView = customTitleView
        
        setupCalender()
        
        self.children.forEach { (vc) in
            if vc is CalendarEventListViewController {
                child = vc as? CalendarEventListViewController
            }
        }
        
        let month = Date().month
        let year = Date().year
        let days = Date().daysInMonth
        
        let start = String(format: "%d-%02d-01", year, month)
        let end = String(format: "%d-%02d-%02d", year, month, days)
        fetchEvents(startDate: start, endDate: end)
    }
    
    private func setTitleDate(date: Date) {
        if date.toString(format: "yyyy") == Date().toString(format: "yyyy") {
            let text = date.toString(format: "MMMM dd") + " ▴"
            dateButton.setTitle(text, for: .normal)
        } else {
            let text = date.toString(format: "MMMM dd, yyyy") + " ▴"
            dateButton.setTitle(text, for: .normal)
        }
    }
}

// MARK: - Actions
extension CalendarViewController {
    
    @objc func viewCalenderButtonAction() {
        
        guard groups.count > 0 else { return }
        
        var text = dateButton.title(for: .normal)
        if isCalendarOpen {
            text = text?.replacingOccurrences(of: "▴", with: "▾")
            listTopConstraint.constant = topListPadding
        } else {
            text = text?.replacingOccurrences(of: "▾", with: "▴")
            listTopConstraint.constant = topListPadding + calenderViewHeight.constant
        }
        isCalendarOpen = !isCalendarOpen
        dateButton.setTitle(text, for: .normal)
    }
   
}

// MARK: - Mediator/Presenter Functions
extension CalendarViewController {
 
    func monthChange(date: Date) {
        selectedDate = date
        setTitleDate(date: date)
    }
    
    func dateChanged(date: Date) {
        selectedDate = date
        setTitleDate(date: date)
        loadChildList()
    }
    
    func loadChildList() {
        let subGroup = groups.filter({ $0.dateString == selectedDate.toString(format: "yyyy-MM-dd") })
        child?.loadEvents(groups: subGroup)
    }
}
