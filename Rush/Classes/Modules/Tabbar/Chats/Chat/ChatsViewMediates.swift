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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let action =  UIContextualAction(style: .normal, title: "Files", handler: { [weak self] (_, _, completionHandler) in
                guard let uwself = self else { return }
                
                let channel = uwself.channels[indexPath.row]
                let name = uwself.getSingleChatName(channel: channel)
                ChatManager().leave(channel, completionHandler: { [weak uwself] (status) in
                    guard let unowned = uwself else { return }
                    if status {
                        let snackbar = TTGSnackbar(message: "\(name) chat was deleted",
                                                   duration: .middle,
                                                   actionText: "",
                                                   actionBlock: { (_) in })
                        snackbar.show()
                        unowned.getListOfGroups()
                    } else {
                        Utils.alert(message: Message.tryAgainErrorMessage)
                    }
                })
                completionHandler(true)
            })
        action.image = UIImage(named: "chat-delete")
        action.backgroundColor = isDarkModeOn ? UIColor.bgBlack17 : UIColor.bgWhite96
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        return confrigation
    }
}
