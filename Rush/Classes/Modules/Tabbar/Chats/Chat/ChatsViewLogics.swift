//
//  ClubListLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChatsViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return chatlist.count
    }
    
    func fillCell(_ cell: ChatListCell, _ indexPath: IndexPath) {
        cell.setup(title: chatlist[indexPath.row])
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        let controller = ChatRoomViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChatsViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.isEmpty {
            chatlist = filterList
            
        } else {
            let filter = chatlist.filter {( $0.lowercased().contains(text.lowercased()))}
            chatlist = filter
        }
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatlist = filterList
        textField.resignFirstResponder()
        return true
    }
}
