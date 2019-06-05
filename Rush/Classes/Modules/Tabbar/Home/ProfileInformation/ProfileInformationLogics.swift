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
        return section == 0 ? 2 : section == 1 ? 3 : 2
    }
    
    func fillCell(_ cell: ProfileInformationCell, _ indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.setup(text: "12.20.1995", placeholder: Text.dateOfBirth)
            } else if indexPath.row == 1 {
                cell.setup(text: "Taken", placeholder: Text.relationship)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.setup(text: "Harvard University", placeholder: Text.university)
            } else if indexPath.row == 1 {
                cell.setup(text: "High school", placeholder: Text.level)
            } else if indexPath.row == 2 {
                cell.setup(text: "Sophomore", placeholder: Text.year)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.setup(text: "Business", placeholder: "")
            } else if indexPath.row == 1 {
                cell.setup(text: "Economics", placeholder: "")
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                cell.setup(text: "Art", placeholder: "")
            } else if indexPath.row == 1 {
                cell.setup(text: "Architecture", placeholder: "")
            }
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        let text = section == 0 ? "Personal" : section == 1 ? "Education" : section == 2 ? "Majors" : section == 3 ? "Minors" : ""
        header.setup(textColor: (section == 2 || section == 3) ? UIColor.bgBlack : UIColor.brown24)
        header.setup(title: text)
        header.setup(isDetailArrowHide: true)
    }
}
