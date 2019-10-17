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
        if screenType == .club {
            if (section == 0 && myClubsList.count > 0) || section > 0 {
                return 50
            }
            return CGFloat.leastNormalMagnitude
        } else {
            if (section == 0 && myClassesList.count > 0) || section > 0 {
                return 50
            }
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 0 {
            return 157
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if screenType == .club {
            if myClubsList.count > 0 && section == 0 {
                return myClubsList.count
            }
            return clubList.count
        } else if screenType == .classes {
            if myClassesList.count > 0 && section == 0 {
                return myClassesList.count
            }
            return classesList.count
        } else {
            return 0
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        if screenType == .club {
            cell.setup(.clubs, nil, myClubsList)
        } else {
            cell.setup(.classes, nil, myClassesList[indexPath.section].myJoinedClass)
        }
        
        cell.cellSelected = {
            [weak self] (type, section, index) in
            guard let unself = self else { return }
            if type == .classes {
                let classObj = unself.classesList[section]
                let subClassesList = classObj.classList
                
                if subClassesList?.count ?? 0 > 0 {
                    let selSubClass = subClassesList?[index]
                    if selSubClass?.myJoinedClass?.count ?? 0 > 0 {
                        //already joined - so dont show groups
                        unself.performSegue(withIdentifier: Segues.classDetailSegue, sender: selSubClass)
                    } else {
                        // not joined yet, so show groups
                         unself.performSegue(withIdentifier: Segues.searchClubSegue, sender: selSubClass )
                    }
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
        if myClubsList.count > 0 {
            let club = myClubsList[indexPath.row]
            let image = Image(json: club.clubPhoto ?? "")
            cell.setup(title: club.clubName ?? "")
            cell.setup(detail: club.clubDesc ?? "")
            cell.setup(invitee: club.invitees)
            cell.setup(imageUrl: image.urlThumb())
        } else if myClassesList.count > 0 {
            let classes = myClassesList[indexPath.row]
            cell.setup(title: classes.name)
            let grpId = classes.myJoinedClass?.first?.groupId
            let nm = classes.classGroups?.filter({ $0.id == grpId })
            if (nm?.count ?? 0) > 0 {
                cell.setup(detail: nm?.first?.name ?? "")
            }
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
            if myClassesList.count > 0 {
                if section == 0 {
                    header.setup(title: Text.myClasses)
                    header.setup(isDetailArrowHide: true)
                } else {
                    header.setup(title: myClassesList[section - 1].name)
                }
            } else {
                header.setup(title: myClassesList[section].name)
            }
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
                let club = clubList[indexPath.row]
                performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else {
                performSegue(withIdentifier: Segues.classDetailSegue, sender: nil)
            }
        }
    }
    
    func loadMoreCell(_ indexPath: IndexPath) {
        
        if screenType == .club {
            if indexPath.section == 0 && isNextPageM == true {
                if indexPath.row == myClubsList.count - 2 {
                    pageNoM += 1
                    getMyClubListAPI(sortBy: "my")
                }
            } else if indexPath.section > 0 && isNextPageO == true {
                if indexPath.section == clubInterestList.count - 2 {
                    pageNoO += 1
                    getClubCategoryListAPI()
                }
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
                     Keys.pageNo: pageNoM] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let uwself = self else { return }
            
            if uwself.pageNoM == 1 {
                uwself.myClubsList.removeAll()
            }
                        
            if let clubs = value, clubs.count > 0 {
                if uwself.pageNoM == 1 {
                    uwself.myClubsList = clubs
                } else {
                    uwself.myClubsList.append(contentsOf: clubs)
                }
                uwself.pageNoM += 1
                uwself.isNextPageM = true
            } else {
                if uwself.pageNoM == 1 || (uwself.pageNoM > 1 && value == nil) {
                    uwself.getClubCategoryListAPI()
                }
            }
            uwself.tableView.reloadData()
        }
    }
    
    func getClassCategoryAPI() {
        let param = [Keys.pageNo: pageNoO] as [String: Any]
        
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classesList = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    func getMyJoinedClasses(search: String) {
        let param = [Keys.pageNo: pageNoM, Keys.search: search] as [String: Any]
        
        ServiceManager.shared.fetchMyJoinedClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.myClassesList = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
            unsafe.getClassCategoryAPI()
        }
    }
    
    func getClubCategoryListAPI() {
        //Utils.showSpinner()
        var params = [Keys.pageNo: "1"]
        params[Keys.search] = searchText
        ServiceManager.shared.fetchClubCategoryList(params: params) { [weak self] (data, _) in
            //Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let category = data {
                unsafe.clubInterestList = category
            }
            unsafe.tableView.reloadData()
        }
    }
}
