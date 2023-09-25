//
//  TableViewExtension.swift
//  Rush
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
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
