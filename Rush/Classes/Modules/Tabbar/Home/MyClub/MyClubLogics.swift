//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension MyClubViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return (section == 0 || section == 1) ? CGFloat(CFloat.leastNormalMagnitude) : 60
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 {
            return interestList.count + 1
        } else if section == 3 {
            return peopleList.count + 1
        }
        return 1
    }
    
    func fillClubNameCell(_ cell: ClubNameCell) {
        
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        if section == 2 {
            header.setup(title: "Joined")
        } else if section == 3 {
            header.setup(title: "Interest tags")
        } else if section == 4 {
            header.setup(title: "Posts")
        }
    }
}

extension MyClubViewController {
    
}
