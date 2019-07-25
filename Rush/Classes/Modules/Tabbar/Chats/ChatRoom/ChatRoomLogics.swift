//
//  ChatRoomPresenter.swift
//  Friends
//
//  Created by iChirag on 28/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit
import SendBirdSDK

extension ChatRoomViewController {
    
    //MARK: - Input View Handler (Or Presenter Output)
    
    func showAddParticipateToast(_ friends: [Friend]) {
        if friends.count > 0 {
            self.updateChannelNameAndImagesOnNav()
            if messageList.count == 0 {
                addEmptyAvatarView()
            }
            
            var name = ""
            
            for friend in friends {
                if name.isEmpty {
                    name = friend.name.smallName + "."
                } else {
                    let smallName  = friend.name.smallName + "."
                    name = "\(name), \(smallName)"
                }
            }
            /*
             name = String(name.dropLast())
             */
            let storyboard = UIStoryboard(name: "CustomPicker", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotificationAlertViewController") as? NotificationAlertViewController
            vc?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc?.toastMessage = "\(name) added."
            present(vc!, animated: true, completion: nil)
        }
    }
    
    
    func loadPrevisouMessages() {
        messageList.removeAll()
        hasPrev = true;
        previousMessageQuery = channel?.createPreviousMessageListQuery()
        loadMessagesWithInitial(initial: true)
    }
    
    func loadMessagesWithInitial(initial:Bool) {
        if (previousMessageQuery?.isLoading()) ?? false {
            Utils.hideSpinner()
            return
        }
        
        if !hasPrev && !initial {
            Utils.hideSpinner()
        }
        
        isLoadFirst = initial
        self.previousMessageQuery?.loadPreviousMessages(withLimit: 30, reverse: !initial, completionHandler: { (messages, error) in
            if error != nil {
                print("Loading previous message error: \(error?.localizedDescription ?? "")")
                Utils.hideSpinner()
                return
            }
            
            if messages != nil && messages!.count > 0 {
                self.parseMessageFromChatServer(messages: messages, initial: initial)
            } else {
                if !initial { //it does not have more previous message
                    self.hasPrev = false
                    /*
                     DispatchQueue.main.async {
                     Utils.alert(message: "You are at last message only!")
                     }*/
                }
                self.chatTableReload(initial: initial)
            }
            self.channel?.markAsRead()
            ChatManager.manager.getUnreadCount({ (int) in
                UIApplication.shared.applicationIconBadgeNumber = int
            })
            Utils.hideSpinner()
        })
    }
    
    
    /*!
     * @discussion more abstract method to parse a  message
     * @param messages an array of received messages
     * @param initial YEs if this is a first load
     * @return a JSQSBMessage
     */
    func parseMessageFromChatServer(messages:[SBDBaseMessage]?, initial:Bool) {
        
        if let messageList = messages {
            for message in messageList {
                let msg = MockMessage(message: message)
                self.messageList.append(msg)
            }
        }
        
        self.messageList =  self.messageList.sorted(by: { (first: MockMessage, second: MockMessage) -> Bool in
            first.sentDate < second.sentDate
        })
        
        // reload the whole chat UI
        DispatchQueue.main.async {
            self.chatTableReload(initial: initial)
        }
    }
    
    func readAllMessages() {
        ChatManager().readMessagesOfChannel(channel: channel) { (status) in
            
        }
    }
}

extension ChatRoomViewController {
    
    func addParticipantInGroup(_ friends: [Friend]?) {
        //MARK: - Add Participate
        var urls = [String]()
        var userIds = [String]()
        var nickNames = [String]()
        
        if let members = channel?.members {
            for member in members {
                if let user = member as? SBDUser {
                    let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                    if loggedInUserId != user.userId {
                        urls.append(user.profileUrl ?? "")
                        nickNames.append(user.nickname ?? "")
                    }
                }
            }
        }
        
        if let friendList = friends {
            for friend in friendList {
                if !userIds.contains(friend.userId) && !ChatManager().isMemberExistInChannel(channel:self.channel, userid: friend.userId)  {
                    urls.append(friend.photo?.thumb ?? "")
                    userIds.append(friend.userId)
                    nickNames.append(friend.name)
                }
            }
        }
        
        //need to add login username as userid is already there
        nickNames.append(Authorization.shared.profile?.name ?? "")
        urls.append(Authorization.shared.profile?.photo?.thumb ?? "")
        
        if userIds.count > 0 {
            let coverUrl = urls.joined(separator: ",")
            let groupNameString = nickNames.joined(separator: ", ")
            
            ChatManager().updateChannel(
                channel: self.channel,
                userIds: userIds,
                groupName: groupNameString,
                coverImageUrl: coverUrl,
                data: "Group",
                completionHandler: {
                    [weak self] (channel) in
                    guard let self_ = self else { return }
                    self_.channel = channel
                    self_.reloadData(true)
                    self_.showAddParticipateToast(friends ?? [])
            }) { (error) in
                
            }
        } else {
            Utils.alert(message: "You can't add existed member again!")
        }
    }
}

// MARK: - MessageCellDelegate
extension ChatRoomViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
       
    }
    
    func didTapImage(mediaItem: MediaItem) {
        /*
        let fullScreenController = FullScreenSlideshowViewController()
        
        var inputs = [InputSource]()
        var inputSource: InputSource {
            if mediaItem.image == nil {
                return ImageSource(url: mediaItem.url!.absoluteString)!
            } else {
                return ImageSource(image: mediaItem.image!)
            }
        }
        inputs.append(inputSource)
        
        fullScreenController.inputs = inputs
        fullScreenController.initialPage = 0
        
        self_.present(fullScreenController, animated: true, completion: nil)
        */
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}
