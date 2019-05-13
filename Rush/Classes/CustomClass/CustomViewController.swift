//
//  CustomViewController.swift
//  Rush
//
//  Created by ideveloper on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension CustomViewController {
    func setupUI() {
        
        view.backgroundColor = UIColor.bgBlack
        
        let bgView = UIView()
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bgView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 24.0
        bgView.clipsToBounds = true
        view.addSubview(bgView)
    }
}
