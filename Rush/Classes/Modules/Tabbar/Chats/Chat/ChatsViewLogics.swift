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
        
        if self.isOpenToShare {
            if let event = sharedEvent {
                //type: 1 == event
                //type: 2 == club
                //type: 3 == class
                
                let month = event.start?.toString(format: "MMM").uppercased() ?? ""
                let datelable = event.start?.toString(format: "dd") ?? ""
                let day = event.start?.toString(format: "EEEE") ?? ""
                var time = event.start?.toString(format: "hh:mma") ?? ""
                if let endDate = event.end {
                    time +=  "-" +  endDate.toString(format: "hh:mma")
                }
                
                let jsonString = "{\"JSON_CHAT\":{\"type\":1,\"eventId\":\"\(event.id)\",\"eventTitle\":\"\(event.title)\",\"eventImage\":\"\(event.photo?.main ?? "")\",\"desc\":\"\(event.desc)\",\"date\":\"\(datelable)\",\"month\":\"\(month)\",\"day\":\"\(day)\",\"time\":\"\(time)\"}}"
                
                sendMessage(text: jsonString, channel: channel)
            }
        } else {
            let controller = ChatRoomViewController()
            controller.hidesBottomBarWhenPushed = true
            controller.isGroupChat = channel.customType == "single" ? false : true
            controller.userName = cell.titleLabel.text ?? ""
            controller.userNavImage = cell.imgView.image
            controller.channel = channel
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func sendMessage(text: String, channel: SBDGroupChannel) {
        ChatManager().sendTextMessage(text, channel: channel, completionHandler: { (message) in
            if message != nil {
                self.delegate?.sharedResult(flg: true)
            } else {
                self.delegate?.sharedResult(flg: false)
            }
            self.dismiss(animated: true, completion: nil)
        }, errorHandler: { (_) in
            self.delegate?.sharedResult(flg: false)
            self.dismiss(animated: true, completion: nil)
        })
    }
        
    func getSingleChatName(channel: SBDGroupChannel) -> String {
        let name = channel.name
        
        if let members = channel.members {
            if members.count == 2 && channel.customType == "single" {
                for member in members {
                    if let user = member as? SBDUser {
                        let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                        if loggedInUserId != user.userId {
                            return user.nickname ?? ""
                        }
                    }
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
            // Right item button
            navigationItem.rightBarButtonItem = nil
        } else {
            let filter = filterList.filter { ( $0.name.lowercased().contains(text) ) }
            channels = filter
            navigationItem.rightBarButtonItem = clearBarButton
        }
        tableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = nil
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
            unself.tableView.reloadData()
            Utils.hideSpinner()
            
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
