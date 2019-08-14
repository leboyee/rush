//
//  CalendarViewController.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CalendarViewController: CustomViewController {

    let selectedDate = Date()
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

//MARK: - Setup
extension CalendarViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight))
        let text = selectedDate.toString(format: "MMMM dd") + " ▾"
        
        dateButton = UIButton(frame: CGRect(x: 0, y: 2, width: titleWidth, height: 30.0))
        dateButton.setTitle(text, for: .normal)
        dateButton.setTitleColor(UIColor.white, for: .normal)
        dateButton.titleLabel?.font = UIFont.DisplayBold(sz: 24)
        dateButton.contentHorizontalAlignment = .left
        dateButton.addTarget(self, action: #selector(viewCalenderButtonAction), for: .touchUpInside)
        customTitleView.addSubview(dateButton)
        navigationItem.titleView = customTitleView
        
        
        let imageView = UIImageView(image: UIImage(named: "calendar"))
        let calendar = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = calendar

        setupCalender()
        
        /*
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        listView.addGestureRecognizer(panGesture)
        panGesture.cancelsTouchesInView = true
        */
        
        self.children.forEach { (vc) in
            if vc is CalendarEventListViewController {
                child = vc as? CalendarEventListViewController
            }
        }
        
        fetchEvents()
    }
    
}

//MARK: - Actions
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
