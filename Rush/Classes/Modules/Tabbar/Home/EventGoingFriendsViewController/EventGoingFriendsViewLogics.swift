//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EventGoingFriendsViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return inviteType == .going ? goingInviteeList.count : notGoingInviteeList.count
    }
    
    func fillCell(_ cell: FriendListCell, _ indexPath: IndexPath) {
        if inviteType == .going {
            let invitee = goingInviteeList[indexPath.row]
            cell.setup(name: invitee.user?.name ?? "")
            if let url = URL(string: invitee.user?.photo?.thumb ?? "") {
                cell.setup(url: url)
            }
        } else {
            let invitee = notGoingInviteeList[indexPath.row]
            cell.setup(name: invitee.user?.name ?? "")
            if let url = URL(string: invitee.user?.photo?.thumb ?? "") {
                cell.setup(url: url)
            }
        }
    }
        
    func willDisplay(_ indexPath: IndexPath) {
        if isNextPageExist == true, indexPath.row == (inviteType == .going ? goingInviteeList.count - 1 : notGoingInviteeList.count - 1) {
            fetchInvitees(search: searchTextFiled?.text ?? "", type: inviteType)
        }
    }
    
    func selectedCell(_ indexPath: IndexPath) {
        let invitee = inviteType == .going ? goingInviteeList[indexPath.row] :  notGoingInviteeList[indexPath.row]
        self.performSegue(withIdentifier: Segues.friendProfileSegue, sender: invitee.user)
    
    }
}

// MARK: - Services
extension EventGoingFriendsViewController {
    
    func fetchInvitees(search: String, type: InviteType) {
        
//        Utils.showSpinner()
        if search.count > 0 {
            task?.cancel()
        }
        let param = [Keys.pageNo: pageNo, Keys.search: search, Keys.inviteType: type ==  .going ? "going" : "not_going"] as [String: Any]
        task = ServiceManager.shared.fetchInviteeListWithSession(eventId: "\(self.eventId)", params: param) { [weak self] (invitees, _, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            if unsafe.isFirstTime == false {
                unsafe.isFirstTime = true
                unsafe.fetchInvitees(search: "", type: .notGoing)
            }
            if type == .going {
                if unsafe.pageNo == 1 {
                    unsafe.goingInviteeList.removeAll()
                }
                if invitees?.count ?? 0 > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.goingInviteeList = invitees ?? [Invitee]()
                    } else {
                        unsafe.goingInviteeList.append(contentsOf: invitees ??  [Invitee]())
                    }
                }
            } else {
                if unsafe.pageNo == 1 {
                    unsafe.notGoingInviteeList.removeAll()
                }
                if invitees?.count ?? 0 > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.notGoingInviteeList = invitees ?? [Invitee]()
                    } else {
                        unsafe.notGoingInviteeList.append(contentsOf: invitees ??  [Invitee]())
                    }
                }
            }
            //unsafe.totalInvitee = total
            unsafe.firstSegmentButton.setTitle("\(unsafe.goingInviteeList.count) going", for: .normal)
            unsafe.secondSegmentButton.setTitle("\(unsafe.notGoingInviteeList.count) not going", for: .normal)
            
            unsafe.tableView.reloadData()
        }
    }
}
