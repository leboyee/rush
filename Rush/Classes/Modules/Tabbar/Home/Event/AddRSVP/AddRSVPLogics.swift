//
//  CreateEventLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

extension AddRSVPViewController {
    
  
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return rsvpArray.count + 1
    }
    
  
    
    func fillRsvpCell(_ cell: RSVPCell, _ indexPath: IndexPath) {
        
        if rsvpArray.count ==  indexPath.row {
            
        } else {
            
        }
      
    }
    
}

// MARK: - Other functions
extension AddRSVPViewController {
    
    func validateAllFields() {
       
    }
}

