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
            cell.setup(.classes, nil, classesList[indexPath.row].classList)
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
            cell.setup(imageUrl: image.urlThumb())
        } else if myClassesList.count > 0 {
            let joinedClass = myClassesList[indexPath.row]
            cell.setup(title: joinedClass.classes?.name ?? "VR Meet")
            cell.setup(detail: joinedClass.classGroup?.name ?? "")
            cell.setup(imageUrl: joinedClass.classes?.photo.photo?.urlThumb())
        }
//            let classes = myClassesList[indexPath.row]
//            cell.setup(title: classes.name)
//            let grpId = classes.myJoinedClass?.first?.groupId
//            let nm = classes.classGroups?.filter({ $0.id == grpId })
//            if (nm?.count ?? 0) > 0 {
//                cell.setup(detail: nm?.first?.name ?? "")
//            }
//        } 
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: false)
        
        if screenType == .club {
            if section == 0 {
                header.setup(title: Text.myClubs)
                header.setup(isDetailArrowHide: true)
            } else {
                let value = clubInterestList[section - 1].name
                header.setup(title: value)
                header.setup(isDetailArrowHide: true)
            }
        } else if screenType == .classes {
            if myClassesList.count > 0 {
                if section == 0 {
                    header.setup(title: Text.myClasses)
                    header.setup(isDetailArrowHide: true)
                } else {
                    header.setup(title: classesList[section - 1].name)
                }
            } else {
                if classesList.count > 0 {
                header.setup(title: classesList[section].name)
                }
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
                let club = myClubsList[indexPath.row]
                performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
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
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "0",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNoM] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, _) in
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
                uwself.isNextPageM = true
            } else {
                if uwself.pageNoM == 1 || (uwself.pageNoM > 1 && value?.count == 0) {
                    uwself.isNextPageM = false
                    uwself.getClubCategoryListAPI()
                }
            }
            uwself.tableView.reloadData()
        }
    }
    
    func getClubCategoryListAPI() {
          
          let params = [Keys.pageNo: pageNoO, Keys.search: searchText] as [String: Any]
          ServiceManager.shared.fetchClubCategoryList(params: params) { [weak self] (data, _) in
              Utils.hideSpinner()
              guard let uwself = self else { return }
              if uwself.pageNoO == 1 {
                  uwself.clubInterestList.removeAll()
              }
                          
              if let clubs = data, clubs.count > 0 {
                  if uwself.pageNoO == 1 {
                      uwself.clubInterestList = clubs
                  } else {
                      uwself.clubInterestList.append(contentsOf: clubs)
                  }
                  uwself.isNextPageO = true
              } else {
                  if uwself.pageNoO == 1 || (uwself.pageNoO > 1 && data?.count == 0) {
                      uwself.isNextPageO = false
                  }
              }
              uwself.tableView.reloadData()
          }
      }
    
    func getMyJoinedClasses(search: String) {
        let param = [Keys.pageNo: pageNoM, Keys.search: search] as [String: Any]
        
        ServiceManager.shared.fetchMyJoinedClassList(params: param) { [weak self] (data, errorMsg) in
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
                if unsafe.pageNoM == 1 || (unsafe.pageNoM > 1 && data?.count == 0) {
                    unsafe.isNextPageM = false
                    unsafe.getClassCategoryAPI()
                }
            }
            unsafe.tableView.reloadData()
        }
        
    }
    
    func getClassCategoryAPI() {
        let param = [Keys.pageNo: pageNoO] as [String: Any]
        
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, errorMsg) in
            guard let uwself = self else { return }
            
            if uwself.pageNoO == 1 {
                uwself.classesList.removeAll()
            }
            
            if let classes = data, classes.count > 0 {
                if uwself.pageNoO == 1 {
                    uwself.classesList = classes
                } else {
                    uwself.classesList.append(contentsOf: classes)
                }
                uwself.isNextPageO = true
            } else {
                if uwself.pageNoO == 1 || (uwself.pageNoO > 1 && data?.count == 0) {
                    uwself.isNextPageO = false
                }
            }
            uwself.tableView.reloadData()
        }
    }
}
