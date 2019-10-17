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
        return inviteeList.count
    }
    
    func fillCell(_ cell: FriendListCell, _ indexPath: IndexPath) {
        let invitee = inviteeList[indexPath.row]
        cell.setup(name: invitee.user?.name ?? "")
        if let url = URL(string: invitee.user?.photo?.thumb ?? "") {
            cell.setup(url: url)
        }

    }

    func fillFriendClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        cell.setup(detail: "SOMM 24-A")
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        if isNextPageExist == true, indexPath.row == inviteeList.count - 1 {
            fetchInvitees(search: searchTextFiled?.text ?? "")
        }
    }
    
    func selectedCell(_ indexPath: IndexPath) {
        let invitee = inviteeList[indexPath.row]
        self.performSegue(withIdentifier: Segues.friendProfileSegue, sender: invitee.user)
    }

}
// MARK: - Services
extension FriendsListViewController {
    
    func fetchInvitees(search: String) {
        if pageNo == 1 {
            inviteeList.removeAll()
        }
        let param = [Keys.pageNo: pageNo, Keys.search: search, Keys.inviteType: inviteType ==  .going ? "going" : "not_going"] as [String : Any]
        ServiceManager.shared.fetchInviteeList(eventId: "\(self.eventId)", params: param) { [weak self] (invitees, total, _) in
                guard let unsafe = self else { return }
                unsafe.inviteeList = invitees ?? [Invitee]()
                //unsafe.totalInvitee = total
            unsafe.firstSegmentButton.setTitle("\(unsafe.inviteeList.count) going", for: .normal)
            unsafe.secondSegmentButton.setTitle("0 not going", for: .normal)

                unsafe.tableView.reloadData()
            }
        }
//    func getEventList(sortBy: GetEventType) {
//        
//        let param = [Keys.profileUserId: userInfo?.userId ?? "0",
//                     Keys.search: "",
//                     Keys.sortBy: sortBy.rawValue,
//                     Keys.pageNo: pageNo] as [String: Any]
//        
//        ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, errorMsg) in
//            Utils.hideSpinner()
//            guard let unsafe = self else { return }
//            if let events = value {
//                unsafe.eventList = events
//                unsafe.tableView.reloadData()
//            } else {
//                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
//            }
//            unsafe.getClubListAPI(sortBy: "joined")
//        }
//    }
//    
}
