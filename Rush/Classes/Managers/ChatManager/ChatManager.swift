//
//  ChatManager.swift
//  Friends
//
//  Created by ideveloper4 on 15/02/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatManager: NSObject {
    
    static let manager = ChatManager()
    var channel: SBDGroupChannel?
    
    override init() {
        super.init()
        SBDMain.add(self as SBDChannelDelegate, identifier: description)
    }
    
    deinit {
        SBDMain.removeConnectionDelegate(forIdentifier: self.description)
    }
    
    func userId() -> String? {
        return SBDMain.getCurrentUser()?.userId
    }
}

// MARK: - Connect and disconnect chat server
extension ChatManager {
    /*
     Connect to chat server
     */
    
    func connectToChatServer(userId: String, username: String, profileImageUrl: String) {
        
        AppDelegate.shared?.registerPushTokenWithSendBird()
        
        SBDMain.connect(withUserId: userId, completionHandler: { (_, error) in
            if error == nil {
                
                //register token if it is pending
                if AppDelegate.shared?.isTokenRegistrationPending == true {
                    AppDelegate.shared?.unregisterPushTokenWithSendBird()
                    AppDelegate.shared?.registerPushTokenWithSendBird()
                }
                
                //Update user information
                self.updateUsername(username, profileImage: profileImageUrl)
                
                //Set unread count
                ChatManager().getUnreadCount({ (count) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateUnreadcount), object: (count))
                })
            } else {
                if let domain = error?.domain {
                    if Int(error?.code ?? 0) == 800120 {
                        let msg = "We are not able to connect to chat server."
                        Utils.alert(message: msg, title: "", buttons: ["Connect again"], cancel: "Cancel", destructive: nil, type: .alert, handler: { (index) in
                            if index == 0 {
                                self.connectToChatServer(userId: userId, username: username, profileImageUrl: profileImageUrl)
                            }
                        })
                    } else {
                        Utils.alert(message: "\(Int(error?.code ?? 0)): \(domain)")
                    }
                }
            }
        })
    }
    
    /*
     Disconnect to chat server
     */
    
    func disconnectFromChatServer() {
        //first unregister token
        AppDelegate.shared?.unregisterPushTokenWithSendBird()
        
        //dissconnect from server
        SBDMain.disconnect(completionHandler: {
        })
    }
}

// MARK: - Get channel and group list
extension ChatManager {
    /*
     Get list of all chat groups
     */
    
    func getListOfAllChatGroups(_ completionHandler: @escaping (_ list: [Any]?) -> Void, errorHandler: @escaping (_ error: Error?) -> Void) {
        let query: SBDGroupChannelListQuery? = SBDGroupChannel.createMyGroupChannelListQuery()
        
        // Include empty group channels.
        query?.includeEmptyChannel = false
        
        query?.order = SBDGroupChannelListOrder.latestLastMessage
        
        query?.limit = 100
        
        let list = [AnyHashable]()
        loadListOfChannels(query: query, channels: list, completionHandler: { (channels) in
            //We can not use direct because new created group come at bottom of list.
            /*
             var sortedList: [Any]? = nil
             if let channelList = channels as? [SBDGroupChannel] {
             sortedList = self_.sortChannelList((channelList))
             }
             */
            completionHandler(channels)
        }, errorHandler: { (_) in
            
        })
    }
    
    /*
     Load list of all chat groups
     */
    
    func loadListOfChannels(query: SBDGroupChannelListQuery?,
                            channels: [AnyHashable]?,
                            completionHandler: @escaping ([Any]?) -> Void,
                            errorHandler: @escaping (Error?) -> Void) {
        var channelsList = channels
        query?.loadNextPage(completionHandler: { (channels, error) in
            
            if error != nil {
                if let error = error {
                    print("Error: \(error)")
                    errorHandler(error)
                }
            } else {
                if let channel = channels {
                    channelsList?.append(contentsOf: channel)
                }
                if query?.hasNext ?? false {
                    self.loadListOfChannels(query: query, channels: channels, completionHandler: completionHandler, errorHandler: errorHandler)
                } else {
                    if let value = channelsList {
                        completionHandler(value)
                    }
                }
            }
        })
    }
}

// MARK: - Read and unread message count
extension ChatManager {
    /*
     Get Unread message count
     */
    
    func getUnreadCount(_ completionHandler: @escaping (_ count: Int) -> Void) {
        SBDMain.getTotalUnreadMessageCount { (unreadCount, _) in
            completionHandler(Int(unreadCount))
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateUnreadcount), object: (unreadCount))
        }
    }
    
    func readMessagesOfChannel(channel: SBDGroupChannel?,
                               completionHandler: @escaping (_ status: Bool) -> Void) {
        SBDMain.markAsRead(withChannelUrls: [channel?.channelUrl ?? ""]) { (error) in
            if error != nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
    
}

// MARK: - Create channel and group
extension ChatManager {
    
    /*
     Create Group channel for one user
     */
    
    func createGroupChannel(userId: String?, name: String?, photoUrl: String?, data: String?, type: String?, completionHandler: @escaping(_ channel: SBDGroupChannel?) -> Void, errorHandler: @escaping(_ error: Error?) -> Void) {
        
        if userId == nil && (userId?.count ?? 0) == 0 {
            return
        }
        
        var groupFriendsList = [String]()
        groupFriendsList.append(userId ?? "")
        groupFriendsList.append(Authorization.shared.profile?.userId ?? "")
        let grpName = "\(Authorization.shared.profile?.name ?? ""), \(name ?? "")"
        let strUrl = "\(Authorization.shared.profile?.photo?.thumb ?? ""), \(photoUrl ?? "")"
        
        createGroupChannelwithUsers(userIds: groupFriendsList, groupName: grpName, coverImageUrl: strUrl, data: data, type: type, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    /*
     Create group channel for n users
     */
    
    func createGroupChannelwithUsers(
        userIds: [Any]?,
        groupName: String?,
        coverImageUrl: String?,
        data: String?,
        type: String?,
        completionHandler: @escaping (_ channel: SBDGroupChannel?) -> Void, errorHandler: @escaping (_ error: Error?) -> Void) {
        
        let sbdGroupChannelParams = SBDGroupChannelParams()
        sbdGroupChannelParams.name = groupName
        sbdGroupChannelParams.isDistinct = type == "single" ? ((userIds?.count == 2) ? true: false) : false
        sbdGroupChannelParams.addUserIds(userIds as? [String] ?? [])
        sbdGroupChannelParams.coverUrl = coverImageUrl
        sbdGroupChannelParams.data = data
        sbdGroupChannelParams.customType = type
        
        SBDGroupChannel.createChannel(with: sbdGroupChannelParams) { (channel, error) in
            if error != nil {
                if let domain = error?.domain {
                    Utils.alert(message: "\(Int(error?.code ?? 0)): \(domain)")
                }
                if let err = error {
                    errorHandler(err)
                }
            } else {
                if let value = channel {
                    completionHandler(value)
                }
            }
        }
    }
}

// MARK: - Get channel and group list
extension ChatManager {
    
    /*
     Get channels
     */
    
    func getChannelWithChannelUrl(_ url: String?, completionHandler: @escaping (_ channel: SBDGroupChannel?) -> Void, errorHandler: @escaping (_ error: Error?) -> Void) {
        SBDGroupChannel.getWithUrl(url!, completionHandler: { channel, error in
            if error == nil {
                if let value = channel {
                    completionHandler(value)
                }
            } else {
                if let err = error {
                    errorHandler(err)
                }
            }
        })
    }
    
    /*
     //Flow of Process as below
     1. Get list of all channels
     2. Filter channel for Group or not
     3. Filter channel for user Id
     4. Return channel
     */
    
    func getChannelForUserId(_ userId: String?,
                             completionHandler: @escaping (_ channel: SBDGroupChannel?) -> Void,
                             errorHandler: @escaping (_ error: Error?) -> Void) {
        
        if userId == nil || (userId?.count ?? 0) == 0 {
            //if errorHandler
            errorHandler(NSError(domain: "com.mobile.friends", code: -11111, userInfo: [
                NSLocalizedDescriptionKey: "user id is nil or blank"
                ]))
            return
        }
        
        //Get all channels
        getListOfAllChatGroups({ list in
            
            //Filter for 'Group' or not
            let predicate = NSPredicate(format: "data <> 'Group'")
            let oneToOneList = (list as NSArray?)?.filtered(using: predicate)
            
            //Filter for member Id
            let predicateUserId = NSPredicate(format: "ANY members.userId = '\(userId ?? "")'")
            let userchannel = (oneToOneList as NSArray?)?.filtered(using: predicateUserId)
            
            if let ch = userchannel?.first as? SBDGroupChannel {
                if (userchannel?.count ?? 0) > 0 {
                    completionHandler(ch)
                } else {
                    completionHandler(nil)
                }
            }
        }, errorHandler: { error in
            errorHandler(error)
        })
    }
}

// MARK: - Update channel
extension ChatManager {
    
    func updateChannel(
        channel: SBDGroupChannel?,
        userIds: [String]?,
        groupName: String?,
        coverImageUrl: String?,
        data: String?,
        type: String?,
        completionHandler: @escaping (_ channel: SBDGroupChannel?) -> Void, errorHandler: @escaping (_ error: Error?) -> Void) {
        
        if let ids = userIds {
            channel?.inviteUserIds(ids, completionHandler: { (error) in
                if error == nil {
                    let params = SBDGroupChannelParams()
                    
                    if groupName != nil {
                        params.name = groupName
                    }
                    
                    if coverImageUrl != nil {
                        params.coverUrl = coverImageUrl
                    }
                    
                    if data != nil {
                        params.data = data
                    }
                    
                    if type != nil {
                        params.customType = type
                    }
                    
                    params.isDistinct = false
                    
                    channel?.update(with: params, completionHandler: { (channel, error) in
                        if error != nil {
                            if let domain = error?.domain {
                                Utils.alert(message: "\(Int(error?.code ?? 0)): \(domain)")
                            }
                            if let err = error {
                                errorHandler(err)
                            }
                        } else {
                            if let value = channel {
                                completionHandler(value)
                            }
                        }
                    })
                } else {
                    if let domain = error?.domain {
                        Utils.alert(message: "\(Int(error?.code ?? 0)): \(domain)")
                    }
                    if let err = error {
                        errorHandler(err)
                    }
                }
            })
        }
    }
    
    func isMemberExistInChannel(channel: SBDGroupChannel?, userid: String) -> Bool {
        return channel?.hasMember(userid) ?? false
    }
    
    func addNewMember(type: String, data: String, userId: String) {
        
        getListOfAllChatGroups({ (value) in
            if let list = value as? [SBDGroupChannel] {
                
                let channels = list.filter({ $0.customType == type })
                if channels.count > 0 {
                    let filteredChannels = channels.filter({ $0.data == data })
                    
                    if filteredChannels.count > 0, let channel = filteredChannels.first {
                        
                        var userIds = [String]()
                        
                        if let members = channel.members {
                            for member in members {
                                if let user = member as? SBDUser {
                                    userIds.append(user.userId)
                                }
                            }
                            userIds.append(userId)
                        }
                        
                        let ids = userIds.joined(separator: ",")
                                                
                        self.updateChannel(channel: channel, userIds: [ids], groupName: channel.name, coverImageUrl: channel.coverUrl, data: channel.data, type: channel.customType, completionHandler: { (_) in
                            
                            print("************ User added successfully  *************")
                            
                        }) { (error) in
                            print(error?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
}

// MARK: - Send message to channel
extension ChatManager {
    /*
     Send text message to channel
     */
    
    // MARK: - messaging
    func sendTextMessage(_ message: String?,
                         channel: SBDGroupChannel?,
                         completionHandler: ((_ channel: SBDUserMessage?) -> Void)? = nil,
                         errorHandler: ((_ error: Error?) -> Void)? = nil) {
        
        channel?.sendUserMessage(message, completionHandler: { userMessage, error in
            if error == nil {
                completionHandler?(userMessage)
            } else {
                errorHandler?(error)
            }
        })
    }
    
    func sendImageFileMessage(_ channel: SBDGroupChannel?,
                              _ imageName: String,
                              completionHandler: ((_ fileMessage: SBDFileMessage?) -> Void)? = nil,
                              errorHandler: ((_ error: Error?) -> Void)? = nil) {
        
        let imageFolder = "\(imageName)"
        let imagePath = Utils.getPathForFileName(imageFolder)
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: imagePath))
            
            channel?.sendFileMessage(
                withBinaryData: data,
                filename: imageName,
                type: "image/jpg",
                size: UInt(data.count),
                data: "",
                completionHandler: { (fileMessage, error) in
                    if error == nil {
                        completionHandler?(fileMessage)
                    } else {
                        errorHandler?(error)
                    }
            })
        } catch {
            
        }
    }
}

// MARK: - Block/Unblock user
extension ChatManager {
    /*
     Block user
     */
    
    // MARK: - Blocked / Unblock
    func blockUserId(_ userId: String, handler completionHandler: ((_ status: Bool) -> Void)? = nil) {
        //Block user in SendBird API
        SBDMain.blockUserId(userId, completionHandler: { (_, error) in

            if completionHandler != nil {
                if error == nil {
                    completionHandler?(true)
                } else {
                    completionHandler?(false)
                }
            }
        })
    }
    
    /*
     Unblock user
     */
    
    func unblockUserId(_ userId: String, handler completionHandler: ((_ status: Bool) -> Void)? = nil) {
        SBDMain.unblockUserId(userId, completionHandler: { error in
            if error == nil {
                completionHandler?(true)
            } else {
                completionHandler?(false)
            }
        })
    }
}

// MARK: - Remove(Leave) from group or channel
extension ChatManager {
    
    /*
     Remove from group
     */
    
    func leave(_ channel: SBDGroupChannel?, completionHandler: ((_ status: Bool) -> Void)? = nil) {
        // Left that channel
        DispatchQueue.main.async(execute: {
            channel?.leave(completionHandler: { error in
                if error == nil {
                    completionHandler?(true)
                } else {
                    completionHandler?(false)
                }
            })
        })
    }
    
    /*
     Leave from group/channel
     */
    
    func leave(userId: String?, completion: ((_ status: Bool) -> Void)? = nil) {
        
        getChannelForUserId(userId, completionHandler: { (channel) in
            if let chnl = channel {
                self.leave(chnl, completionHandler: { (status) in
                    if status {
                        completion?(true)
                    } else {
                        completion?(false)
                    }
                })
            } else {
                completion?(false)
            }
        }, errorHandler: { (_) in
            completion?(false)
        })
    }
    
    /*
     Leave/Exit from group chat
     */
    
    func exitFromGroup(_ channel: SBDGroupChannel?, completionHandler: @escaping (_ status: Bool) -> Void, errorHandler: @escaping (_ error: Error?) -> Void) {
        
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
                        userIds.append(user.userId)
                    }
                }
            }
        }
        
        if userIds.count > 0 {
            let coverUrl = urls.joined(separator: ",")
            let groupNameString = nickNames.joined(separator: ", ")
            
            self.updateChannel(channel: channel,
                               userIds: userIds,
                               groupName: groupNameString,
                               coverImageUrl: coverUrl,
                               data: "Group",
                               type: "",
                               completionHandler: { (_) in
                                self.leave(channel) { (status) in
                                    if status {
                                        completionHandler(true)
                                    } else {
                                        completionHandler(true)
                                    }
                                }
            }, errorHandler: { (error) in
                errorHandler(error)
            })
        }
    }
}

// MARK: - Update userInfo
extension ChatManager {
    
    /*
     Update user info
     */
    
    // MARK: - Update Info
    func updateUsername(_ username: String?, profileImage profileImageUrl: String?) {
        // update the user name
        SBDMain.updateCurrentUserInfo(withNickname: username, profileUrl: profileImageUrl, completionHandler: { (_) in
        })
    }
}

// MARK: - SBDChannelDelegate
extension ChatManager: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        //Set unread count
        ChatManager().getUnreadCount { (count) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateUnreadcount), object: (count))
        }
    }
}

// MARK: - Private Methods
extension ChatManager {
    func sortChannelList(_ channels: [SBDGroupChannel]) -> [SBDGroupChannel] {
        
        var channelList = channels
        let numberOfElements = channelList.count
        if numberOfElements <= 1 {
            return channelList
        }
        
        let randomPivotPoint = numberOfElements / 2
        let pivotChannel = channels[randomPivotPoint]
        let pivotDate = getDateFor(pivotChannel)
        
        channelList.remove(at: randomPivotPoint)
        
        var lessArray = [SBDGroupChannel]()
        lessArray.reserveCapacity(numberOfElements)
        
        var moreArray = [SBDGroupChannel]()
        moreArray.reserveCapacity(numberOfElements)
        
        for channel in channelList {
            if channel.members?.count == 1 {
                self.leave(channel, completionHandler: { status in
                    if status {
                        print("Channel Removed")
                    }
                })
            } else {
                let date: Date? = getDateFor(channel)
                
                if let firstDate = date {
                    if let finalDate = pivotDate {
                        if self.isLaterThanDate(firstDate, finalDate) {
                            lessArray.append(channel)
                        } else {
                            moreArray.append(channel)
                        }
                    }
                }
            }
        }
        
        var sortedlist = [SBDGroupChannel]()
        sortedlist.reserveCapacity(numberOfElements)
        
        sortedlist.append(contentsOf: sortChannelList(lessArray))
        sortedlist.append(pivotChannel)
        sortedlist.append(contentsOf: sortChannelList(moreArray))
        
        lessArray.removeAll()
        moreArray.removeAll()
        
        return sortedlist
    }
    
    func isLaterThanDate(_ date: Date, _ compareDate: Date) -> Bool {
        return date.compare(compareDate) == .orderedDescending
    }
    
    func getDateFor(_ channel: SBDGroupChannel?) -> Date? {
        var msgDate: Date?
        if let channelDetail = channel {
            if channelDetail.lastMessage == nil {
                msgDate = Date(timeIntervalSince1970: TimeInterval(channelDetail.createdAt))
            } else {
                if let created = channelDetail.lastMessage?.createdAt {
                    msgDate = Date(timeIntervalSince1970: TimeInterval(created / 1000))
                } else {
                    return msgDate
                }
            }
        } else {
            return msgDate
        }
        return msgDate
    }
}

// MARK: - Others
extension ChatManager {
    func getChatName(_ channel: SBDGroupChannel?) -> String {
        
        var groupName = ""
        if let members = channel?.members {
            for member in members {
                
                if let user = member as? SBDUser {
                    let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                    if loggedInUserId != user.userId {
                        if groupName.isEmpty {
                            groupName = user.nickname ?? ""
                        } else {
                            groupName += ", " + (user.nickname ?? "")
                        }
                    }
                }
                
                let index = members.index(of: member)
                if index >= 5 {
                    break
                }
            }
        }
        return groupName
    }
}
