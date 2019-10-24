//
//  ClubListMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import MGSwipeTableCell

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.chatListCell, bundle: nil), forCellReuseIdentifier: Cell.chatListCell)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.chatListCell, for: indexPath) as? ChatListCell else { return UITableViewCell() }
        cell.delegate = self
        cell.tag = indexPath.row
        /*
         https://www.wrike.com/open.htm?id=410229719
         */
        cell.rightButtons = [MGSwipeButton(title: "", icon: #imageLiteral(resourceName: "chat-delete"), backgroundColor: nil)]
        cell.rightSwipeSettings.transition = .border
        cell.rightExpansion.buttonIndex = 0
        cell.rightExpansion.fillOnTrigger = true
        fillCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        
        let channel = channels[cell.tag]
        let name = getSingleChatName(channel: channel)
        ChatManager().leave(channel, completionHandler: { [weak self] (status) in
            guard let unowned = self else { return }
            if status {
                let snackbar = TTGSnackbar(message: "\(name) chat was deleted",
                                           duration: .middle,
                                           actionText: "",
                                           actionBlock: { (_) in
                                            // Utils.notReadyAlert()
                })
                snackbar.show()
                unowned.getListOfGroups()
            } else {
                Utils.alert(message: Message.tryAgainErrorMessage)
            }
        })
        return true
    }
}
