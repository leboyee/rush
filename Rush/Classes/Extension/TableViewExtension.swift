//
//  TableViewExtension.swift
//  Rush
//
//  Created by kamal on 26/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension UITableView {
    func register(cellName: String) {
        register(
            UINib(nibName: cellName, bundle: nil),
            forCellReuseIdentifier: cellName
        )
    }
    
    func register(reusableViewName: String) {
        register(
            UINib(nibName: reusableViewName, bundle: nil),
            forHeaderFooterViewReuseIdentifier: reusableViewName
        )
    }
}
