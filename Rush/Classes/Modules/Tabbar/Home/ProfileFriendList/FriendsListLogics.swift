//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension FriendsListViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if type == .events || type == .clubs || type == .friends {
            if firstSegmentButton.isSelected {
                return firstTabList.count
            } else {
                return secondTabList.count
            }
        } else if type == .classes {
            return myClassesList.count
        }
        return inviteeList.count
    }
    
    func fillCell(_ cell: FriendListCell, _ indexPath: IndexPath) {
        if type == .friends {
            var friend = Friend()
            if firstSegmentButton.isSelected {
                friend = firstTabList[indexPath.row] as? Friend ?? friend
            } else {
                friend = secondTabList[indexPath.row] as? Friend ?? friend
            }
            cell.setup(name: friend.user?.name ?? "")
            let str = friend.user?.photo?.thumb ?? ""
            let url = URL(string: str)
            cell.setup(url: url)
            /*  if let url = URL(string: friend.user?.photo?.thumb ?? "") {
             cell.setup(url: url)
             } else {
             guard inviteeList.count > indexPath.row else { return }
             let invitee = inviteeList[indexPath.row]
             cell.setup(name: invitee.user?.name ?? "")
             if let url = URL(string: invitee.user?.photo?.thumb ?? "") {
             cell.setup(url: url)
             }
             }*/
        } else  if type == .clubJoinedUsers {
            var friend = Invitee()
            friend = inviteeList[indexPath.row]
            cell.setup(name: friend.user?.name ?? "")
            if let url = URL(string: friend.user?.photo?.thumb ?? "") {
                cell.setup(url: url)
            } else {
                let invitee = inviteeList[indexPath.row]
                cell.setup(name: invitee.user?.name ?? "")
                cell.setup(url: URL(string: invitee.user?.photo?.thumb ?? ""))
            }
        } else  if type == .classRoasters {
            var friend = Invitee()
            if inviteeList.count > indexPath.row {
                friend = inviteeList[indexPath.row]
                cell.setup(name: friend.user?.name ?? "")
                if let url = URL(string: friend.user?.photo?.thumb ?? "") {
                    cell.setup(url: url)
                } else {
                    let invitee = inviteeList[indexPath.row]
                    cell.setup(name: invitee.user?.name ?? "")
                    cell.setup(url: URL(string: invitee.user?.photo?.thumb ?? ""))
                }
            }
        }
    }
    
    func fillFriendClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        
        if type == .clubs {
            let club: Club?
            if firstSegmentButton.isSelected {
                club = firstTabList[indexPath.row] as? Club
            } else {
                club = secondTabList[indexPath.row] as? Club
            }
            let image = Image(json: club?.clubPhoto ?? "")
            cell.setup(title: club?.clubName ?? "")
            cell.setup(detail: club?.clubDesc ?? "")
            cell.setup(invitee: club?.invitees)
            cell.setup(clubImageUrl: image.urlThumb())
            
            if let count = club?.clubTotalJoined, count > 3 {
                cell.setup(inviteeCount: count - 3)
            } else {
                cell.setup(inviteeCount: 0)
            }
        } else if type == .classes {
            let joinedClass = myClassesList[indexPath.row]
            cell.setup(title: joinedClass.classes?.name ?? "VR Meet")
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
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        var event = Event()
        if firstSegmentButton.isSelected {
            event = firstTabList[indexPath.row] as? Event ?? event
        } else {
            event = secondTabList[indexPath.row] as? Event ?? event
        }
        cell.setup(cornerRadius: 24)
        cell.setup(isHideSeparator: false)
        cell.setup(title: event.title)
        cell.setup(date: event.start)
        cell.setup(start: event.start, end: event.end)
        cell.setup(eventImageUrl: event.photo?.urlThumb())
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        
        if type == .classes && indexPath.row == myClassesList.count - 3 && isNextPageExist == true {
            pageNo += 1
            getMyJoinedClasses()
        } else if isNextPageExist == true, indexPath.row == inviteeList.count - 3 {
            if type == .clubJoinedUsers {
                pageNo += 1
                fetchClubInviteeAPI()
            } else if type == .classRoasters {
                pageNo += 1
                fetchClassRostersAPI()
            } else {
                fetchInvitees(search: searchTextFiled?.text ?? "")
            }
        } else if firstTabNextPageExist == true, indexPath.row == firstTabList.count - 3 {
            firstTabPageNo += 1
            if type == .events {
                getAttendingEventList()
            } else if type == .clubs {
                getJoinedClubListAPI()
            } else if type == .friends {
                getFriendsListAPI()
            }
        } else if secondTabNextPageExist == true, indexPath.row == secondTabList.count - 3 {
            secondTabPageNo += 1
            if type == .events {
                getManagedEventList()
            } else if type == .clubs {
                getManagedClubList()
            } else if type == .friends {
                getMutualFriendsListAPI()
            }
        }
    }
    
    func selectedCell(_ indexPath: IndexPath) {
        if type == .events {
            var event: Event?
            if firstSegmentButton.isSelected {
                event = firstTabList[indexPath.row] as? Event
            } else {
                event = secondTabList[indexPath.row] as? Event
            }
            performSegue(withIdentifier: Segues.eventDetailSegue, sender: event)
        } else if type == .clubs {
            var club: Club?
            if firstSegmentButton.isSelected {
                club = firstTabList[indexPath.row] as? Club
            } else {
                club = secondTabList[indexPath.row] as? Club
            }
            performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
        } else if type == .friends {
            var friend: Friend?
            if firstSegmentButton.isSelected {
                friend = firstTabList[indexPath.row] as? Friend
                
                if friend?.user?.userId == Authorization.shared.profile?.userId {
                    if tabBarController?.selectedIndex == 3 {
                        navigationController?.popToRootViewController(animated: false)
                    } else {
                        tabBarController?.selectedIndex = 3
                    }
                } else {
                    performSegue(withIdentifier: Segues.otherUserProfile, sender: friend)
                }
            } else {
                
                friend = secondTabList[indexPath.row] as? Friend
                if friend?.user?.userId == Authorization.shared.profile?.userId {
                    if tabBarController?.selectedIndex == 3 {
                        navigationController?.popToRootViewController(animated: false)
                    } else {
                        tabBarController?.selectedIndex = 3
                    }
                } else {
                    performSegue(withIdentifier: Segues.otherUserProfile, sender: friend)
                }
            }
            
        } else  if type == .classes {
            var myclass: ClassJoined?
            if firstSegmentButton.isSelected {
                myclass = myClassesList[indexPath.row]
            } else {
                myclass = myClassesList[indexPath.row]
            }
            performSegue(withIdentifier: Segues.classDetailSegue, sender: myclass)
        } else {
            let invitee = inviteeList[indexPath.row]
            
            if invitee.user?.userId == Authorization.shared.profile?.userId {
                if tabBarController?.selectedIndex == 3 {
                    navigationController?.popToRootViewController(animated: false)
                } else {
                    tabBarController?.selectedIndex = 3
                }
            } else {
                self.performSegue(withIdentifier: Segues.otherUserProfile, sender: invitee.user)
            }
        }
    }
}

// MARK: - Services
extension FriendsListViewController {
    
    func fetchInvitees(search: String) {
        if pageNo == 1 {
            inviteeList.removeAll()
        }
        noDataLabel.text = "No Invitees Available"
        let param = [Keys.pageNo: pageNo, Keys.search: search, Keys.inviteType: inviteType ==  .going ? "going" : "not_going"] as [String: Any]
        ServiceManager.shared.fetchInviteeList(eventId: "\(self.eventId)", params: param) { [weak self] (invitees, _, _) in
            guard let unsafe = self else { return }
            unsafe.inviteeList = invitees ?? [Invitee]()
            //unsafe.totalInvitee = total
            unsafe.firstSegmentButton.setTitle("\(unsafe.inviteeList.count) going", for: .normal)
            unsafe.secondSegmentButton.setTitle("0 not going", for: .normal)
            unsafe.tableView.reloadData()
        }
    }
    
    func getAttendingEventList() {
        
        if firstTabPageNo == 1 {
            firstTabList .removeAll()
        }
        let param = [Keys.profileUserId: userInfo?.userId ?? "",
                     Keys.search: "",
//                     Keys.sortBy: GetEventType.attending.rawValue,
                     Keys.pageNo: firstTabPageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventList(sortBy: GetEventType.attending.rawValue, params: param) { [weak self] (value, total, _) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            
            if let list = value {
                if list.count > 0 {
                    let firstTitle = "\(total) Attending"
                    unsafe.firstSegmentButton.setTitle(firstTitle, for: .normal)
                    if unsafe.firstTabPageNo == 1 {
                        unsafe.firstTabList = list
                    } else {
                        unsafe.firstTabList.append(contentsOf: list)
                    }
                    unsafe.firstTabNextPageExist = true
                } else {
                    unsafe.firstTabNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getManagedEventList() {
        if secondTabPageNo == 1 {
            secondTabList .removeAll()
        }
        
        let param = [Keys.profileUserId: userInfo?.userId ?? "",
                     Keys.search: "",
                   //  Keys.sortBy: GetEventType.my.rawValue,
                     Keys.pageNo: secondTabPageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventList(sortBy: GetEventType.my.rawValue, params: param) { [weak self] (value, total, _) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            if let list = value {
                
                if list.count > 0 {
                    let secondTitle = "\(total) Managed"
                    unsafe.secondSegmentButton.setTitle(secondTitle, for: .normal)
                    if unsafe.secondTabPageNo == 1 {
                        unsafe.secondTabList = list
                    } else {
                        unsafe.secondTabList.append(contentsOf: list)
                    }
                    unsafe.secondTabNextPageExist = true
                } else {
                    unsafe.secondTabNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getJoinedClubListAPI() {
        if firstTabPageNo == 1 {
            firstTabList .removeAll()
        }
        
        let param = [Keys.search: "",
                     Keys.sortBy: "joined",
                     Keys.pageNo: firstTabPageNo,
                     Keys.profileUserId: userInfo?.userId ?? "0"] as [String: Any]
        
        ServiceManager.shared.fetchClubList(sortBy: "joined", params: param) { [weak self] (value, total, _) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            
            if let list = value {
                if list.count > 0 {
                    let firstTitle = "\(total) Joined"
                    unsafe.firstSegmentButton.setTitle(firstTitle, for: .normal)
                    
                    if unsafe.firstTabPageNo == 1 {
                        unsafe.firstTabList = list
                    } else {
                        unsafe.firstTabList.append(contentsOf: list)
                    }
                    unsafe.firstTabNextPageExist = true
                } else {
                    unsafe.firstTabNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getManagedClubList() {
        if secondTabPageNo == 1 {
            secondTabList .removeAll()
        }
        
        let param = [Keys.profileUserId: userInfo?.userId ?? "",
                     Keys.search: "",
                     Keys.sortBy: "my",
                     Keys.pageNo: secondTabPageNo] as [String: Any]
        
        ServiceManager.shared.fetchClubList(sortBy: "my", params: param) { [weak self] (value, total, _) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            if let list = value {
                
                if list.count > 0 {
                    let secondTitle = "\(total) Managed"
                    unsafe.secondSegmentButton.setTitle(secondTitle, for: .normal)
                    
                    if unsafe.secondTabPageNo == 1 {
                        unsafe.secondTabList = list
                    } else {
                        unsafe.secondTabList.append(contentsOf: list)
                    }
                    unsafe.secondTabNextPageExist = true
                } else {
                    unsafe.secondTabNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getFriendsListAPI() {
             
        if firstTabPageNo == 1 {
            firstTabList .removeAll()
        }
        
        let param = [Keys.profileUserId: userInfo?.userId ?? "",
                     Keys.search: "",
                     Keys.isMutual: "0",
                     Keys.pageNo: firstTabPageNo] as [String: Any]
        
        ServiceManager.shared.fetchFriendsList(params: param) { [weak self] (value, total, _) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            
            if let list = value {
                
                if list.count > 0 {
                    let value = total == 1 ? "Friend" : "Friends"
                    let firstTitle = "\(total) \(value)"
                    unsafe.firstSegmentButton.setTitle(firstTitle, for: .normal)
                    if unsafe.firstTabPageNo == 1 {
                        unsafe.firstTabList = list
                    } else {
                        unsafe.firstTabList.append(contentsOf: list)
                    }
                    unsafe.firstTabNextPageExist = true
                } else {
                    unsafe.firstTabNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getMutualFriendsListAPI() {
        if secondTabPageNo == 1 {
            secondTabList .removeAll()
        }
        
        let param = [Keys.profileUserId: userInfo?.userId ?? "",
                     Keys.search: "",
                     Keys.isMutual: "1",
                     Keys.pageNo: secondTabPageNo] as [String: Any]
        
        ServiceManager.shared.fetchFriendsList(params: param) { [weak self] (value, total, _) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            if let list = value {
                
                if list.count > 0 {
                    let secondTitle = "\(total) Mutual"
                    unsafe.secondSegmentButton.setTitle(secondTitle, for: .normal)
                    if unsafe.secondTabPageNo == 1 {
                        unsafe.secondTabList = list
                    } else {
                        unsafe.secondTabList.append(contentsOf: list)
                    }
                    unsafe.secondTabNextPageExist = true
                } else {
                    unsafe.secondTabNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getMyJoinedClasses() {
        noDataLabel.text = "\(userInfo?.name ?? "User") has not joined any classes yet"
        if pageNo == 1 {
            myClassesList .removeAll()
        }
        var param = [Keys.pageNo: pageNo, Keys.search: ""] as [String: Any]
        if userInfo != nil {
            param[Keys.profileUserId] = userInfo?.userId
        }
        ServiceManager.shared.fetchMyJoinedClassList(params: param) { [weak self] (value, _) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            
            if let list = value {
                if list.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.myClassesList = list
                    } else {
                        unsafe.myClassesList.append(contentsOf: list)
                    }
                    unsafe.isNextPageExist = true
                } else {
                    unsafe.isNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
            
        }
    }
    
    func fetchInvitees(search: String, type: InviteType) {
        noDataLabel.text = "No invitees found"
        Utils.showSpinner()
        let param = [Keys.pageNo: pageNo, Keys.search: search, Keys.inviteType: type ==  .going ? "going" : "not_going"] as [String: Any]
        ServiceManager.shared.fetchInviteeList(eventId: "\(self.eventId)", params: param) { [weak self] (invitees, _, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            if unsafe.isFirstTime == false {
                unsafe.isFirstTime = true
                unsafe.fetchInvitees(search: "", type: .notGoing)
            }
            if type == .going {
                unsafe.goingInviteeList = invitees ?? [Invitee]()
            } else {
                unsafe.notGoingInviteeList = invitees ?? [Invitee]()
            }
            //unsafe.totalInvitee = total
            unsafe.firstSegmentButton.setTitle("\(unsafe.goingInviteeList.count) going", for: .normal)
            unsafe.secondSegmentButton.setTitle("\(unsafe.notGoingInviteeList.count) not going", for: .normal)
            
            unsafe.tableView.reloadData()
        }
    }
    
    func fetchClubInviteeAPI() {
        noDataLabel.text = ""
        if pageNo == 1 {
            inviteeList.removeAll()
        }
        
        let param = [Keys.search: searchText,
                     Keys.clubId: clubId ?? "0",
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchClubInviteeList(clubId: clubId ?? "0", params: param) { [weak self] (value, _, _) in
            guard let unsafe = self else { return }
            if let list = value {
                if list.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.inviteeList = list
                    } else {
                        unsafe.inviteeList.append(contentsOf: list)
                    }
                    unsafe.isNextPageExist = true
                } else {
                    if unsafe.inviteeList.count == 0 && unsafe.searchText.isNotEmpty {
                        unsafe.noDataLabel.text = "No results found"
                    } else {
                        unsafe.noDataLabel.text = "No one has joined this club yet"
                    }
                    unsafe.isNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func fetchClassRostersAPI() {
        noDataLabel.text = ""
              
        if pageNo == 1 {
            inviteeList.removeAll()
        }
        
        let param = [Keys.search: searchText,
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchClassGroupRostersList(classId: classId, groupId: groupId, params: param) { [weak self] (value, _, _) in
            guard let unsafe = self else { return }
            if let list = value {
                if list.count > 0 {
                    if unsafe.pageNo == 1 {
                        var rosterArray = [Invitee]()
                        for rs in list {
                            if let user = rs.user {
                                let inv = Invitee()
                                inv.user = user
                                rosterArray.append(inv)
                            }
                        }
                        unsafe.inviteeList = rosterArray
                    } else {
                        var rosterArray = [Invitee]()
                        for rs in list {
                            if let user = rs.user {
                                let inv = Invitee()
                                inv.user = user
                                rosterArray.append(inv)
                            }
                        }
                        unsafe.inviteeList = rosterArray
                    }
                    unsafe.isNextPageExist = true
                } else {
                    if unsafe.inviteeList.count == 0 && unsafe.searchText.isNotEmpty {
                        unsafe.noDataLabel.text = "No results found"
                    } else {
                        unsafe.noDataLabel.text = "There are no rosters in this class"
                    }
                    unsafe.isNextPageExist = false
                }
            }
            unsafe.tableView.reloadData()
        }
    }
}
