//
//  ClubListMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import MGSwipeTableCell

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        fillCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension ChatsViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
           return true
    }
       
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        swipeSettings.transition = MGSwipeTransition.border
        swipeSettings.threshold = 0.4
        expansionSettings.buttonIndex = 0
        if direction == MGSwipeDirection.rightToLeft {
            expansionSettings.fillOnTrigger = true
            expansionSettings.threshold = 3
            //let color = UIColor.clear//UIColor.init(red:0.0, green:122/255.0, blue:1.0, alpha:1.0)
            
            return [
                MGSwipeButton(title: "", icon: UIImage(named: "chat-delete"), backgroundColor: UIColor.clear, callback: { (cell) -> Bool in
                    
                    if let path = self.tableView.indexPath(for: cell) {
                        let channel = self.channels[path.row]
                        let name = self.getSingleChatName(channel: channel)
                        cell.hideSwipe(animated: true)
                        ChatManager().leave(channel, completionHandler: { [weak self] (status) in
                            guard let unowned = self else { return }
                            if status {
                                let snackbar = TTGSnackbar(message: "\(name) chat was deleted",
                                                           duration: .middle,
                                                           actionText: "",
                                                           actionBlock: { (_) in })
                                snackbar.show()
                                unowned.getListOfGroups(isFromPush: false, url: "")
                            } else {
                                Utils.alert(message: Message.tryAgainErrorMessage)
                            }
                        })
                    }
                    
                    return true
                })
            ]
        }
        
        return []
    }
}
