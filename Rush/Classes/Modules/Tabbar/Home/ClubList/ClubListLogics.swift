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
        if section == 0 && myClubList.count > 0 {
            return 50
        } else {
            return myClassesList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        }
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if (screenType == .club)
        {
            return UITableView.automaticDimension
        } else {
            return myClassesList.count > 0 ? 157 : CGFloat.leastNormalMagnitude
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if myClubList.count > 0 && screenType == .club && section == 0 {
            return myClubList.count
        } else if myClassesList.count > 0 && screenType == .classes {
           return myClassesList.count
        } else {
            return 0
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        if screenType == .club {
            if indexPath.section == 1 {
                cell.setup(.clubs, nil, nil)
            } else if indexPath.section == 2 {
                cell.setup(.clubs, nil, nil)
            } else {
                cell.setup(.clubs, nil, nil)
            }
        } else {
//            if indexPath.section == 1 {
//                cell.setup(.classes, nil, nil)
//            } else if indexPath.section == 2 {
//                cell.setup(.classes, nil, nil)
//            } else {
            
                cell.setup(.classes, nil, myClassesList[indexPath.section].classList)
//            }
        }
        
        cell.cellSelected = {
            [weak self] (type, section, index) in
            guard let unself = self else { return }
            if type == .classes {
                let classObj = unself.myClassesList[section]
                let subClassesObj = classObj.classList
                
                if subClassesObj?.count ?? 0 > 0 {
                    unself.performSegue(withIdentifier: Segues.searchClubSegue, sender: subClassesObj?[index])
                }
            }
        }
    }
    
    func fillMyClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.setup(topConstraint: -16)
        } else {
            cell.setup(topConstraint: 0)
        }
        if myClubList.count > 0 {
            let club = myClubList[indexPath.row]
            let image = Image(json: club.clubPhoto ?? "")
            cell.setup(title: club.clubName ?? "")
            cell.setup(detail: club.clubDesc ?? "")
            cell.setup(invitee: club.invitees)
            cell.setup(imageUrl: image.urlThumb())
        } else if myClassesList.count > 0 {
//            let classes = myClassesList[indexPath.row]
//            cell.setup(title: classes.clubName ?? "")
//            cell.setup(detail: classes.clubDesc ?? "")
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
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
            header.setup(title: myClassesList[section].name)
            /*if section == 0 {
                header.setup(title: Text.myClasses)
                header.setup(isDetailArrowHide: true)
            } else if section == 1 {
                header.setup(title: "Arts & humanities")
            } else if section == 2 {
                header.setup(title: "Business & managment")
            }*/
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            // Open other user profile UI for test
            
            if unself.screenType == .club {
                
            } else {
                // self_.performSegue(withIdentifier: Segues.openPostScreen , sender: nil)
            }
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            if screenType == .club {
                let club = myClubList[indexPath.row]
                performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else {
                performSegue(withIdentifier: Segues.classDetailSegue, sender: nil)
            }
        }
    }
}

// MARK: - Services
extension ClubListViewController {
    func getMyClubListAPI(sortBy: String) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "0",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let uwself = self else { return }
            if let clubs = value {
                uwself.myClubList = clubs
                uwself.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    func getClassCategoryAPI() {
        let param = [Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.myClassesList = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
