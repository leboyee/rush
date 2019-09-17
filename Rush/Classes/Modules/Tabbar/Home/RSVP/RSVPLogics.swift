//
//  RSVPLogics.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Other Function
extension RSVPViewController {
    
}

// MARK: - Handlers
extension RSVPViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        let count = 2
        return count
    }
    
    func fillCell(_ cell: JoinRSVPCell, _ indexPath: IndexPath) {
        cell.setup(placeholder: "Do you have any experience in VR?")
        cell.setup(answer: "")
        
        cell
    }
}

// MARK: - API's
extension RSVPViewController {

}
