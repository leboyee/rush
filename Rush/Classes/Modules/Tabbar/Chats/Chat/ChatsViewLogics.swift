//
//  ClubListLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SendBirdSDK

extension ChatsViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return channels.count
    }
    
    func fillCell(_ cell: ChatListCell, _ indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        cell.setup(title: getSingleChatName(channel: channel))
        cell.setup(lastMessage: channel.lastMessage)
        cell.setup(onlineUser: channel.members)
        cell.setup(channel: channel)
        
        if channel.customType == "single" {
            cell.setup(chatImage: channel.members)
        } else {
            cell.setup(img: channel.coverUrl)
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatListCell else { return }
        
        let channel = channels[indexPath.row]
        
        let controller = ChatRoomViewController()
        controller.hidesBottomBarWhenPushed = true
        controller.isGroupChat = channel.customType == "single" ? false : true
        controller.userName = cell.titleLabel.text ?? ""
        controller.userNavImage = cell.imgView.image
        controller.channel = channel
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func getSingleChatName(channel: SBDGroupChannel) -> String {
        let name = channel.name
        let names = name.components(separatedBy: ",")
        if names.count > 1 {
            let loggedInUserName = Authorization.shared.profile?.name ?? ""
            var updateName = ""
            for nm in names {
                if !nm.contains(loggedInUserName) {
                    updateName = nm.trimmingCharacters(in: .whitespacesAndNewlines)
                    return updateName
                }
            }
         }
        return name
    }
}

extension ChatsViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        let text = textField.text?.lowercased() ?? ""
        if text.isEmpty {
            channels = filterList
            
        } else {
            let filter = filterList.filter { ( $0.name.lowercased().contains(text) ) }
            channels = filter
        }
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        channels = filterList
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Services
extension ChatsViewController {
    
    @objc func getListOfGroups() {
        
        ChatManager().getListOfAllChatGroups({ [weak self] (list) in
            guard let unself = self else { return }
            if let list = list as? [SBDGroupChannel] {
                unself.channels = list
                unself.filterList = list
            }
            DispatchQueue.main.async {
                unself.tableView.reloadData()
                Utils.hideSpinner()
            }
            
            if unself.channels.count > 0 {
                unself.blankView.isHidden = true
            } else {
                unself.blankView.isHidden = false
            }
            }, errorHandler: { error in
                Utils.hideSpinner()
                Utils.alert(message: error.debugDescription)
        })
    }
}
