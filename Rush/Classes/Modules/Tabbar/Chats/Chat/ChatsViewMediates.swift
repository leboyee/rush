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
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.chatListCell, for: indexPath) as! ChatListCell
        cell.delegate = self
        cell.rightButtons = [MGSwipeButton(title: "", icon: #imageLiteral(resourceName: "chat-delete"), backgroundColor: nil)]
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
        Utils.alert(message: "Are you sure you want to delete?",buttons: ["Yes", "No"], handler: { (index) in
            if index == 0 {
                self.tableView.reloadData()
                let snackbar = TTGSnackbar(message: "Fine art chat was deleted",
                                           duration: .middle,
                                           actionText: "Undo",
                                           actionBlock: { (snackbar) in
                                            Utils.notReadyAlert()
                })
                snackbar.show()
            }
        })
        return true
    }
}
