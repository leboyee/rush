//
//  ProfileInformationLogics.swift
//  Rush
//
//  Created by ideveloper on 04/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ProfileInformationViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        let text = section == 0 ? "Personal" : section == 1 ? "Education" : section == 2 ? "Majors" : section == 3 ? "Minors" : ""
        header.setup(title: text)
        header.setup(isDetailArrowHide: true)
    }
}
