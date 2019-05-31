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
    
    func fillEventCell(_ cell: EventCell,_ indexPath: IndexPath) {
        cell.setup(type: type)
    }
    
    func fillUserCell(_ cell: UserCell,_ indexPath: IndexPath) {
        
    }
    
    func cellSelectedEvent(_ indexPath: IndexPath) {
        
    }
    
    func cellSize() -> CGSize {
        if cellType == .event {
            return CGSize(width: 224, height: 157)
        } else if cellType == .clubUser {
            return CGSize(width: 72, height: 88)
        } else {
            return CGSize.zero
        }
    }
    
}
