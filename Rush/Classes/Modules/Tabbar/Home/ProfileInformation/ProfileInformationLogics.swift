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
        return section == 0 ? 2 : section == 1 ? 3 : section == 2 ? (userInfo?.majors?.count ?? 0) : section == 3 ? (userInfo?.minors?.count ?? 0) : 0
    }
    
    func fillCell(_ cell: ProfileInformationCell, _ indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.setup(text: "-", placeholder: Text.dateOfBirth)
                if let date = userInfo?.birthDate {
                    if let birthDate = Date.parse(dateString: date, format: "yyyy-MM-dd") {
                        let birth = birthDate.toString(format: "MM.dd.yyyy")
                        cell.setup(text: birth, placeholder: Text.dateOfBirth)
                    }
                }
            } else if indexPath.row == 1 {
                if let value = userInfo?.relationship, value.isNotEmpty {
                    cell.setup(text: value, placeholder: Text.relationship)
                } else {
                    cell.setup(text: "-", placeholder: Text.relationship)
                }
            } else {
                cell.setup(text: "", placeholder: "")
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0, let university = userInfo?.university?.last {
                cell.setup(text: university.universityName, placeholder: Text.university)
            } else if indexPath.row == 1 {
                cell.setup(text: userInfo?.educationLevel ?? "", placeholder: Text.level)
            } else if indexPath.row == 2 {
                cell.setup(text: userInfo?.educationYear ?? "", placeholder: Text.year)
            }
        } else if indexPath.section == 2 {
           let major = userInfo?.majors?[indexPath.row]
            cell.setup(text: major?.majorName ?? "", placeholder: "")
        } else if indexPath.section == 3 {
            let minor = userInfo?.minors?[indexPath.row]
            cell.setup(text: minor?.minorName ?? "", placeholder: "")
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        let text = section == 0 ? Text.personal : section == 1 ? Text.education : section == 2 ? Text.majors : section == 3 ? Text.minors : ""
        header.setup(textColor: (section == 2 || section == 3) ? (isDarkModeOn ? .white : UIColor.bgBlack) : UIColor.brown24)
        header.setup(title: text)
        header.setup(isDetailArrowHide: true)
    }
}
