//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreateClubViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 50
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
    
    func fillTextIconCell(_ cell: TextIconCell, _ indexPath: IndexPath) {
        
        cell.resetAllField()
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.setup(iconImage: "club-gray-1")
            cell.setup(placeholder: Text.nameClub, title: "")
            cell.setup(isUserInterfaceEnable: true)
        } else if indexPath.section == 1 {
            cell.setup(placeholder: Text.addDesc, title: "")
        } else if indexPath.section == 2 {
            if indexPath.row == interestList.count {
                cell.setup(placeholder: "", title: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addInterest : Text.addAnotherInterest)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isUserInterfaceEnable: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", title: interestList[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "interest-gray" : "")
        } else if indexPath.section == 3 {
            
            if indexPath.row == peopleList.count {
                cell.setup(placeholder: "", title: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.invitePeople : Text.inviteOtherPeople)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isUserInterfaceEnable: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", title: peopleList[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "friend-gray" : "")
        } else {
            cell.setup(placeholder: "", title: Text.createGroupChat)
            cell.setup(isShowSwitch: true)
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            guard let self_ = self else { return }
            if indexPath.section == 2 {
                if !self_.interestList.contains(text) {
                    self_.interestList.append(text)
                    self_.tableView.reloadData()
                }
            } else if indexPath.section == 3 {
                if !self_.peopleList.contains(text) {
                    self_.peopleList.append(text)
                    self_.tableView.reloadData()
                }
            }
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            
            if indexPath.section == 2 {
                if let index = self_.interestList.index(of: (self_.interestList[indexPath.row])) {
                    self_.interestList.remove(at: index)
                    self_.tableView.reloadData()
                }
            } else if indexPath.section == 3 {
                if let index = self_.peopleList.index(of: (self_.peopleList[indexPath.row])) {
                    self_.peopleList.remove(at: index)
                    self_.tableView.reloadData()
                }
            }
        }
        
        cell.switchValueChanged = { [weak self] (isOn) in
            guard let _ = self else { return }
            
        }
    }
    
    func fillTextViewCell(_ cell: TextViewCell, _ indexPath: IndexPath) {
        
    }
}
