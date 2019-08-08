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
        let dateButton = UIButton(frame: CGRect(x: 0, y: 2, width: titleWidth, height: 30.0))
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

    }
    
}

//MARK: - Actions
extension CalendarViewController {
    
    @objc func viewCalenderButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func calenderButtonAction() {
       
    }
}
