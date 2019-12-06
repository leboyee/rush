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
    
    func createNewChatGroup(handler: @escaping (_ channel: SBDGroupChannel?) -> Void) {
        
        var grpName = ""
        var loggedInUserId = Authorization.shared.profile?.userId ?? ""
        var otherUserId = ""
        var imgUrl = ""
        var type = ""
        var data = ""
        
        let loggedInUserName = Authorization.shared.profile?.name ?? ""
        let loggedInUserImg = Authorization.shared.profile?.photo?.thumb ?? ""
        var totalUserIds = [String]()
        
        if let friend = friendProfile {
            otherUserId = friend.user?.userId ?? "0"
            imgUrl = (friend.user?.photo?.thumb ?? "") + "," + loggedInUserImg
            grpName = (friend.user?.name ?? "") + ", " + loggedInUserName
            type = "single"
            data = friend.user?.userId ?? "0"
            totalUserIds.append(otherUserId)
        } else if let club = clubInfo {
            otherUserId = club.invitees?.compactMap({ $0.user?.userId }).joined(separator: ",") ?? "0"
            loggedInUserId = club.user?.userId ?? "0"
            imgUrl = club.photo?.thumb ?? ""
            grpName = club.clubName ?? ""
            type = "club"
            data = "\(club.clubId)"
            if let value = club.invitees?.compactMap({ $0.user?.userId }) {
                totalUserIds.append(contentsOf: value)
            }
        } else if let event = eventInfo {
            otherUserId = event.invitees?.compactMap({ $0.user?.userId }).joined(separator: ",") ?? "0"
            loggedInUserId = event.creator?.userId ?? "0"
            imgUrl = event.photo?.thumb ?? ""
            grpName = event.title
            type = "event"
            data = "\(event.id)"
            if let value = event.invitees?.compactMap({ $0.user?.userId }) {
                totalUserIds.append(contentsOf: value)
            }
        } else if let cls = subclassInfo, let rosters = rosterArray {
            otherUserId = rosters.compactMap({ $0.user?.userId }).joined(separator: ",")
            imgUrl = cls.photo?.thumb ?? ""
            grpName = cls.name
            type = "class"
            data = cls.id
            let value = rosters.compactMap({ $0.user?.userId })
            totalUserIds.append(contentsOf: value)
        }
        
        totalUserIds.append(loggedInUserId)
        
        ChatManager().getChannelByTypeData(type, data, completionHandler: { (channel) in
            if channel != nil {
                handler(channel)
            } else {
                //create new channel
                self.createNewGroupChannelwithUsers(totalUserIds: totalUserIds, grpName: grpName, imgUrl: imgUrl, data: data, type: type, completionHandler: handler) { (_) in
                    print("SOMETHING WRONG IN CREATE NEW CHANNEL")
                }
            }
        }, errorHandler: { (_) in
            //create new channel
            self.createNewGroupChannelwithUsers(totalUserIds: totalUserIds, grpName: grpName, imgUrl: imgUrl, data: data, type: type, completionHandler: handler) { (_) in
                print("SOMETHING WRONG IN CREATE NEW CHANNEL")
            }
        })
    }
    
    func createNewGroupChannelwithUsers(
           totalUserIds: [Any],
           grpName: String?,
           imgUrl: String?,
           data: String?,
           type: String?,
           completionHandler: @escaping (_ channel: SBDGroupChannel?) -> Void, errorHandler: @escaping (_ error: Error?) -> Void) {
           
        ChatManager().createGroupChannelwithUsers(userIds: totalUserIds, groupName: grpName, coverImageUrl: imgUrl, data: data, type: type, completionHandler: { (channel1) in
            DispatchQueue.main
                .async(execute: {
                    // Move on Chat detail screen
                    if channel1?.members?.count == totalUserIds.count - 1 {
                        completionHandler(channel1)
                    } else {
                        var channelUserIds = [String]()
                        if let members = channel1?.members {
                            for member in members {
                                if let user = member as? SBDUser {
                                    channelUserIds.append(user.userId)
                                }
                            }
                        }
                        var filteredIds = [String]()
                        for filterId in totalUserIds {
                            if channelUserIds.contains(filterId as? String ?? "") == false {
                                filteredIds.append(filterId as? String ?? "")
                            }
                        }
                        
                        if filteredIds.count > 0 {
                            ChatManager().updateChannel(channel: channel1, userIds: filteredIds, groupName: grpName, coverImageUrl: imgUrl, data: data, type: type, isShowAlert: true, completionHandler: { (channel2) in
                                completionHandler(channel2)
                            }, errorHandler: { (_) in
                                print("SOMETHING WRONG IN UPDATE USER IN NEW CHANNEL")
                            })
                        } else {
                            completionHandler(channel1)
                        }
                    }
                })
        }, errorHandler: {_ in
            print("SOMETHING WRONG IN CREATE NEW CHANNEL")
        })
    }
    
    func insertMessage(_ message: MockMessage) {
        
        messageList.append(message)
        
        if messageList.count == 0 {
            emptyPlaceholderView(isHide: false)
        } else {
            emptyPlaceholderView(isHide: true)
        }
        
        /*
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
        */
    }
    
    func showAddParticipateToast(_ friends: [Friend]) {
        if friends.count > 0 {
            self.updateChannelNameAndImagesOnNav()
            if messageList.count == 0 {
                emptyPlaceholderView(isHide: false)
            }
            
            var name = ""
            
            for friend in friends {
                if name.isEmpty {
                    name = (friend.user?.name ?? "").smallName + "."
                } else {
                    let smallName  = (friend.user?.name.smallName ?? "") + "."
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
        hasPrev = true
        previousMessageQuery = channel?.createPreviousMessageListQuery()
      
        loadMessagesWithInitial(initial: true)
    }
    
    func loadMessagesWithInitial(initial: Bool) {
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
    func parseMessageFromChatServer(messages: [SBDBaseMessage]?, initial: Bool) {
        
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
        
        let count = Int(channel?.unreadMessageCount ?? 0)
        
        ChatManager().readMessagesOfChannel(channel: channel) { (status) in
            if status, count > 0 {
                UIApplication.shared.applicationIconBadgeNumber -= count
            }
        }
    }
}

extension ChatRoomViewController {
    
    // MARK: - Add Participate
    func addParticipantInGroup(_ friends: [Friend]?) {
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
                if !userIds.contains(friend.user?.userId ?? "0") && !ChatManager().isMemberExistInChannel(channel: self.channel, userid: (friend.user?.userId ?? "0")) {
                    urls.append(friend.user?.photo?.thumb ?? "")
                    userIds.append((friend.user?.userId ?? "0"))
                    nickNames.append(friend.user?.name ?? "")
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
                data: self.channel?.data, type: self.channel?.customType, isShowAlert: true,
                completionHandler: { [weak self] (channel) in
                    guard let unself = self else { return }
                    unself.channel = channel
                    unself.reloadData(true)
                    unself.showAddParticipateToast(friends ?? [])
                }, errorHandler: { _ in })
        } else {
            Utils.alert(message: "You can't add existed member again!")
        }
    }
    
    func updateUserImage() {
        if friendProfile != nil {
            if channel != nil {
                let img = friendProfile?.user?.photo?.thumb ?? ""
                emptyUserImageView.sd_setImage(with: URL(string: img), completed: nil)
                updateChannelNameAndImagesOnNav()
            } else {
                let img = friendProfile?.user?.photo?.thumb ?? ""
                emptyUserImageView.sd_setImage(with: URL(string: img), completed: nil)
                
                userNameNavLabel.text = friendProfile?.user?.name ?? ""
                let imgUser = friendProfile?.user?.photo?.thumb ?? ""
                showSingleOrGroupPhotos(photoURL: imgUser)
            }
        } else {
            var imgName = ""
            if let members = channel?.members {
                for member in members {
                    if let user = member as? SBDUser {
                        let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                        if loggedInUserId != user.userId {
                            imgName = user.profileUrl ?? ""
                            break
                        }
                    }
                }
            }
            
            if imgName.isEmpty {
                emptyUserImageView.sd_setImage(with: URL(string: updateChatUserImage()), completed: nil)
            } else {
                emptyUserImageView.sd_setImage(with: URL(string: imgName), completed: nil)
            }
            
            var nm = self.userName
            nm = nm.replacingOccurrences(of: ", ", with: "")
            nm = nm.replacingOccurrences(of: ",", with: "")
            userNameNavLabel.text = nm
            
            showSingleOrGroupPhotos(photoURL: updateChatUserImage())
        }
    }
    
    func showSingleOrGroupPhotos(photoURL: String?) {
        if photoURL != nil {
            if self.channel == nil || (self.channel?.members?.count ?? 0) <= 2 {
                //single photo
                userNavImageView.isHidden = false
                //                userNavImageView.sd_setImage(with: URL(string: photo), completed: nil)
            }
        }
    }
    
    func updateChatUserImage() -> String {
        
        var imageName = ""
        
        if self.channel != nil {
            if self.channel?.customType == "single" {
                if let members = self.channel?.members {
                    // _ = Array<NSURL>()
                    if members.count == 2 && self.channel?.data != "Group" {
                        for member in members {
                            if let user = member as? SBDUser {
                                let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                                if loggedInUserId != user.userId {
                                    imageName = user.profileUrl ?? ""
                                    self.userName = user.nickname ?? ""
                                    self.profileUserId = user.userId
                                }
                            }
                        }
                    } else if members.count == 1 {
                        self.userName = Utils.onlyDisplayFirstNameOrLastNameFirstCharacter(Utils.removeLoginUserNameFromChannel(channelName: self.channel?.name ?? ""))
                        
                        if let url = self.channel?.coverUrl, url.isNotEmpty {
                            let images = url.components(separatedBy: ",")
                            for image in images where image != Authorization.shared.profile?.photo?.thumb {
                                imageName = image
                            }
                        }
                    } else {
                        var chatName = ChatManager().getChatName(self.channel)
                        chatName = Utils.onlyDisplayFirstNameOrLastNameFirstCharacter(chatName)
                        self.userName = chatName
                        
                        if let url = self.channel?.coverUrl {
                            imageName = url
                        }
                    }
                }
            } else {
                imageName = channel?.coverUrl ?? ""
                userName = channel?.name ?? ""
            }
        } else if let frnd = friendProfile {
            imageName = frnd.user?.photo?.thumb ?? ""
            userName = frnd.user?.name ?? ""
        } else {
            /*
             Setup for club, event, class group chat
             Cover image url,
             Group name
             */
            if channel != nil {
                imageName = channel?.coverUrl ?? ""
                userName = channel?.name ?? ""
            } else if let event = eventInfo {
                imageName = event.photo?.thumb ?? ""
            } else if let club = clubInfo {
                imageName = club.photo?.thumb ?? ""
            } else if let cls = subclassInfo {
                imageName = cls.photo?.thumb ?? ""
            }
        }
        return imageName
    }
}

// MARK: - Helpers
extension ChatRoomViewController {
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].sender == messageList[indexPath.section - 1].sender
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].sender == messageList[indexPath.section + 1].sender
    }
    
    func setTypingIndicatorHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        /*
        //updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
        if self.isLastSectionVisible() == true {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
        messagesCollectionView.scrollToBottom(animated: true)
        */
    }
}
