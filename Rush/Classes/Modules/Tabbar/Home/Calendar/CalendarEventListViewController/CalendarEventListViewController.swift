//
//  CalendarEventListViewController.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CalendarEventListViewController: UIViewController {

    let radius: CGFloat = 32.0
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}


extension CalendarEventListViewController {
    
    private func setup() {
        
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = radius
        
        
    }
    
}
