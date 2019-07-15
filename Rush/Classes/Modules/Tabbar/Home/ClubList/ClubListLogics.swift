//
//  ClubListLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ClubListViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && isShowJoinEvents {
            return UITableView.automaticDimension
        } else {
            return 157
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if isShowJoinEvents && section == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        if screenType == .club {
            if indexPath.section == 1 {
                cell.setup(.clubs, nil)
            } else if indexPath.section == 2 {
                cell.setup(.clubs, nil)
            } else {
                cell.setup(.clubs, nil)
            }
        } else {
            if indexPath.section == 1 {
                cell.setup(.classes, nil)
            } else if indexPath.section == 2 {
                cell.setup(.classes, nil)
            } else {
                cell.setup(.classes, nil)
            }
        }
        
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let self_ = self else { return }
            if type == .classes {
                self_.performSegue(withIdentifier: Segues.searchClubSegue, sender: nil)
            }
        }
    }
    
    func fillMyClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.setup(topConstraint: -16)
        } else {
            cell.setup(topConstraint: 0)
        }
        cell.setup(detail: "We have you to code better")
    }
    
    func fillTextHeader(_ header: TextHeader,_ section: Int) {
        header.setup(isDetailArrowHide: false)
        
        if screenType == .club {
            if section == 0 {
                header.setup(title: Text.myClubs)
                header.setup(isDetailArrowHide: true)
            } else if section == 1 {
                header.setup(title: "Sports")
            } else if section == 2 {
                header.setup(title: "Art")
            } else if section == 3 {
                header.setup(title: "Technologies")
            }
        } else {
            if section == 0 {
                header.setup(title: Text.myClasses)
                header.setup(isDetailArrowHide: true)
            } else if section == 1 {
                header.setup(title: "Arts & humanities")
            } else if section == 2 {
                header.setup(title: "Business & managment")
            }
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            // Open other user profile UI for test
            
            if self_.screenType == .club {
                
            } else {
                // self_.performSegue(withIdentifier: Segues.openPostScreen , sender: nil)
            }
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            if screenType == .club {
                performSegue(withIdentifier: Segues.clubDetailSegue, sender: nil)
            } else {
                performSegue(withIdentifier: Segues.classDetailSegue, sender: nil)
            }
        }
    }
}
