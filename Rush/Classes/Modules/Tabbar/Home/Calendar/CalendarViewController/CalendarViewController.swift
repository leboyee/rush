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
    var events: [CalendarItem] {
        didSet {
            events = events.sorted(by: {
                if let d1 = $0.start, let d2 = $1.start {
                   return d1.compare(d2) == .orderedAscending
                }
                return false
            })
        }
    }
}

class CalendarViewController: CustomViewController {

    var selectedDate = Date()
    let titleHeight: CGFloat = 44
    let titleWidth: CGFloat = screenWidth - 110
    let topListPadding: CGFloat = 13.0

    var groups = [EventGroup]()
    var child: CalendarEventListViewController?
    var isScheduledAnything: Bool = false
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calenderView: CalendarView!
    @IBOutlet weak var calenderViewHeight: NSLayoutConstraint!
    
    var dateButton: UIButton!
    var isCalendarOpen = true
    var isFirstTimeOnly = true /// which is used for handle firts time close open calendar

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calenderView.reloadMonth()
        self.calenderView.isHidden = false
    }
}

// MARK: - Setup
extension CalendarViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight))
        let text = selectedDate.toString(format: "MMMM dd") + " ▴"
        
        dateButton = UIButton(frame: CGRect(x: 0, y: 2, width: titleWidth, height: 30.0))
        dateButton.setTitle(text, for: .normal)
        dateButton.setTitleColor(UIColor.white, for: .normal)
        dateButton.titleLabel?.font = UIFont.displayBold(sz: 24)
        dateButton.contentHorizontalAlignment = .left
        dateButton.titleLabel?.lineBreakMode = .byTruncatingTail
        dateButton.titleLabel?.minimumScaleFactor = 0.8
        dateButton.addTarget(self, action: #selector(viewCalenderButtonAction), for: .touchUpInside)
        customTitleView.addSubview(dateButton)
        navigationItem.titleView = customTitleView
        
        setupCalender()
        
        self.children.forEach { (vc) in
            if vc is CalendarEventListViewController {
                child = vc as? CalendarEventListViewController
            }
        }
        
        calenderView.isHidden = true
        calenderView.setSelectedDate(date: selectedDate)
        loadEvents(date: selectedDate)
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
    
    private func loadEvents(date: Date) {
        let month = date.month
        let year = date.year
        let days = date.daysInMonth
        
        let start = String(format: "%d-%02d-01", year, month)
        let end = String(format: "%d-%02d-%02d", year, month, days)
        fetchEvents(startDate: start, endDate: end)
    }
    
    private func toggleCalendar(isOpen: Bool) {
        var text = dateButton.title(for: .normal)
        if isOpen == false {
            text = text?.replacingOccurrences(of: "▴", with: "▾")
            listTopConstraint.constant = topListPadding
        } else {
            text = text?.replacingOccurrences(of: "▾", with: "▴")
            listTopConstraint.constant = topListPadding + calenderViewHeight.constant
        }
        self.isCalendarOpen = isOpen
        self.dateButton.setTitle(text, for: .normal)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            //self.isCalendarOpen = isOpen
            //self.dateButton.setTitle(text, for: .normal)
        })
    }
}

// MARK: - Actions
extension CalendarViewController {
    
    @objc func viewCalenderButtonAction() {
        //guard isScheduledAnything else { return }
        if isCalendarOpen {
            toggleCalendar(isOpen: false)
        } else {
            toggleCalendar(isOpen: true)
        }
    }
   
}

extension CalendarViewController {
    func reloadEvents() {
       loadEvents(date: selectedDate)
    }
}

// MARK: - Mediator/Presenter Functions
extension CalendarViewController {
 
    func monthChange(date: Date) {
        selectedDate = date
        setTitleDate(date: date)
        loadEvents(date: date)
    }
    
    func dateChanged(date: Date) {
        selectedDate = date
        setTitleDate(date: date)
        loadChildList()
    }
    
    func loadChildList() {
        let subGroup = groups.filter({ $0.dateString == selectedDate.toString(format: "yyyy-MM-dd") })
        child?.loadEvents(groups: subGroup, isSchedule: isScheduledAnything)
    }
    
    func updateView() {
        if isScheduledAnything == false, isFirstTimeOnly {
            toggleCalendar(isOpen: false)
            isFirstTimeOnly = false
        }
        /// load month calendar
        self.calenderView.reloadMonth()
    }
}
