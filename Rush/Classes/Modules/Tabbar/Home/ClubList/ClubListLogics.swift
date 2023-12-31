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
            if section == 0 {
                return myClubsList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
            } else {
                if (clubInterestList[section - 1].clubArray?.count ?? 0) > 0 {
                    return 50
                }
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
            if screenType == .club {
                if (clubInterestList[indexPath.section - 1].clubArray?.count ?? 0) > 0 {
                    return 157
                } else {
                    return CGFloat.leastNormalMagnitude
                }
            } else {
                if indexPath.section > 0 {
                    return 157
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if screenType == .club {
            if section == 0 {
                return myClubsList.count
            }
            return 1
        } else if screenType == .classes {
            if section == 0 {
                return myClassesList.count
            }
            return 1
        } else {
            return 0
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        if screenType == .club {
            cell.setup(.clubs, nil, clubInterestList[indexPath.section - 1].clubArray)
        } else {
            /*if myClassesList.count > 0 {
             if indexPath.section == 0 {
             cell.setup(.classes, nil, myClassesList)
             } else { */
            if classesList.count > indexPath.section - 1 {
                cell.setup(.classes, nil, classesList[indexPath.section - 1].classList)
            }
            /*  }
             } else {
             cell.setup(.classes, nil, classesList)
             }*/
        }
        
        cell.cellSelected = {
            [weak self] (type, section, index) in
            guard let unself = self else { return }
            
            if type == .clubs {
                let club = unself.clubInterestList[indexPath.section - 1].clubArray?[index]
                unself.performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else if type == .classes {
                let classObj = unself.classesList[indexPath.section - 1]
                let subClassesList = classObj.classList
                
                if subClassesList?.count ?? 0 > 0 {
                    let selSubClass = subClassesList?[index]
                    if selSubClass?.myJoinedClass?.count ?? 0 > 0 {
                        //already joined - so dont show groups
                        unself.performSegue(withIdentifier: Segues.classDetailSegue, sender: selSubClass)
                    } else {
                        // not joined yet, so show groups
                        unself.performSegue(withIdentifier: Segues.searchClubSegue, sender: selSubClass)
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
            cell.setup(clubImageUrl: image.urlThumb())
            if club.clubTotalJoined > 3 {
                cell.setup(inviteeCount: club.clubTotalJoined - 3)
            } else {
                cell.setup(inviteeCount: 0)
            }
        } else if myClassesList.count > 0 {
            let joinedClass = myClassesList[indexPath.row]
            cell.setup(title: joinedClass.classes?.name ?? "")
            cell.setup(detail: joinedClass.classGroup?.name ?? "")
            cell.setup(classesImageUrl: joinedClass.classes?.photo?.urlThumb())
            var rosterArray = [Invitee]()
            for rs in joinedClass.classGroup?.classGroupRosters ?? [ClassJoined]() {
                if let user = rs.user {
                    let inv = Invitee()
                    inv.user = user
                    rosterArray.append(inv)
                }
            }
            cell.setup(invitee: rosterArray)
            
            if let count = joinedClass.classGroup?.totalRosters, count > 3 {
                cell.setup(inviteeCount: count - 3)
            } else {
                cell.setup(inviteeCount: 0)
            }
            
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: false)
        
        if screenType == .club {
            if section == 0 {
                header.setup(title: Text.myClubs)
                header.setup(isDetailArrowHide: true)
            } else {
                guard clubInterestList.count > section - 1 else { return }
                let value = clubInterestList[section - 1].interestName
                header.setup(title: value)
//                header.setup(isDetailArrowHide: true)
            }
        } else if screenType == .classes {
            // if myClassesList.count > 0 {
            if section == 0 {
                header.setup(title: Text.myClasses)
                header.setup(isDetailArrowHide: true)
            } else {
                guard classesList.count > section - 1 else { return }
                header.setup(title: classesList[section - 1].name)
            }
            /*  } else {
             if classesList.count > 0 {
             header.setup(title: classesList[section].name)
             }
             }*/
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            // Open other user profile UI for test
            
            if unself.screenType == .club {
                guard unself.clubInterestList.count > section - 1 else { return }
                               let category = unself.clubInterestList[section - 1]
                               unself.performSegue(withIdentifier: Segues.eventCategorySegue, sender: category)
            } else if unself.screenType == .classes {
                guard unself.classesList.count > section - 1 else { return }
                let category = unself.classesList[section - 1]
                unself.performSegue(withIdentifier: Segues.eventCategorySegue, sender: category)
           }
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            if screenType == .club {
                if myClubsList.count > indexPath.row {
                    let club = myClubsList[indexPath.row]
                           performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
                }
            } else {
                let classGroup = myClassesList[indexPath.row]
                performSegue(withIdentifier: Segues.classDetailSegue, sender: classGroup)
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
        } else if screenType == .classes {
            if indexPath.section == 0 && isNextPageM == true {
                if indexPath.row == myClassesList.count - 2 {
                    pageNoM += 1
                    getMyJoinedClasses(search: "")
                }
            } else if indexPath.section > 0 && isNextPageO == true {
                if indexPath.section == classesList.count - 2 {
                    pageNoO += 1
                    getClassCategoryAPI()
                }
            }
        }
    }
}

// MARK: - Services
extension ClubListViewController {
    func getMyClubListAPI(sortBy: String) {
        
        var param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "0",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNoM] as [String: Any]
        if isFromHomeScreen {
            param[Keys.universityId] = Authorization.shared.profile?.university?.first?.universtiyId ?? 0
        }
        
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, _, _) in
            guard let uwself = self else { return }
            
            if let clubs = value, clubs.count > 0 {
                if uwself.pageNoM == 1 {
                    uwself.myClubsList = clubs
                } else {
                    uwself.myClubsList.append(contentsOf: clubs)
                }
                uwself.isNextPageM = true
            } else {
                uwself.isNextPageM = false
                if uwself.pageNoM == 1 {
                    uwself.myClubsList.removeAll()
                }
            }
            Utils.hideSpinner()
            uwself.tableView.reloadData()
        }
    }
    
    func getClubCategoryListAPI() {
        
        var param = [Keys.pageNo: pageNoO, Keys.search: searchText] as [String: Any]
        
        if isFromHomeScreen {
            param[Keys.universityId] = Authorization.shared.profile?.university?.first?.universtiyId ?? 0
        }
        
        ServiceManager.shared.fetchClubCategoryList(params: param) { [weak self] (data, _) in
            Utils.hideSpinner()
            guard let uwself = self else { return }
            if let clubs = data, clubs.count > 0 {
                if uwself.pageNoO == 1 {
                    uwself.clubInterestList = clubs
                } else {
                    uwself.clubInterestList.append(contentsOf: clubs)
                }
                uwself.isNextPageO = true
            } else {
                uwself.isNextPageO = false
                if uwself.pageNoO == 1 {
                    uwself.clubInterestList.removeAll()
                }
            }
            uwself.tableView.reloadData()
        }
    }
    
    func getMyJoinedClasses(search: String) {
        
        let param = [Keys.pageNo: pageNoM, Keys.search: search] as [String: Any]
        ServiceManager.shared.fetchMyJoinedClassList(params: param) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if unsafe.pageNoM == 1 {
                unsafe.myClassesList.removeAll()
            }
            if let classes = data, classes.count > 0 {
                if unsafe.pageNoM == 1 {
                    unsafe.myClassesList = classes
                } else {
                    unsafe.myClassesList.append(contentsOf: classes)
                }
                unsafe.isNextPageM = true
            } else {
                unsafe.isNextPageM = false
                if unsafe.pageNoM == 1 {
                    unsafe.myClassesList.removeAll()
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getClassCategoryAPI() {
        
        var param = [Keys.pageNo: pageNoO, Keys.search: searchText] as [String: Any]
        
        if isFromHomeScreen {
            param[Keys.universityId] = Authorization.shared.profile?.university?.first?.universtiyId ?? 0
        }
        
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, _) in
            guard let uwself = self else { return }
            
            if let classes = data, classes.count > 0 {
                if uwself.pageNoO == 1 {
                    uwself.classesList = classes
                } else {
                    uwself.classesList.append(contentsOf: classes)
                }
                uwself.isNextPageO = true
            } else {
                uwself.isNextPageO = false
                if uwself.pageNoO == 1 {
                    uwself.classesList.removeAll()
                }
            }
            uwself.tableView.reloadData()
        }
    }
}
