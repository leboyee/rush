//
//  CustomViewController.swift
//  Rush
//
//  Created by ideveloper on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomUI()
    }
}

extension CustomViewController {
    func setupCustomUI() {
        view.backgroundColor = isDarkModeOn ? UIColor.black : UIColor.black
    }
}
