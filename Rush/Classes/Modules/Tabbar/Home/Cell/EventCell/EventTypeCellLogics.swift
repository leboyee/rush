//
//  PhotoTableViewCellPresenter.swift
//  AutoBuyer
//
//  Created by ideveloper on 23/01/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import UIKit

extension EventTypeCell {
    
    func cellCount(_ section: Int) -> Int {
        return 10
    }
    
    func fillCell(_ cell: EventCell,_ indexPath: IndexPath) {
        if type == .upcoming {
            
        } else if type == .clubs {
            cell.setup(isHideDateView: true)
            cell.setup(isHidePrivacyView: true)
        } else if type == .classes {
            cell.setup(isShowCategotyView: true)
        }
    }
    
    func cellSelectedEvent(_ indexPath: IndexPath) {
        
    }
    
    func cellSize() -> CGSize {
        return CGSize(width: 224, height: 157)
    }
    
}
