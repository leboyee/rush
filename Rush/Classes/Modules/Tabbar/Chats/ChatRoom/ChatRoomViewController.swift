//
//  ChatRoomViewController.swift
//  GotFriends
//
//  Created by iChirag on 22/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit
import Photos
import SendBirdSDK
import AVFoundation
import IQKeyboardManagerSwift

class ChatRoomViewController: ChatViewController {
    
    let outgoingAvatarOverlap: CGFloat = 17.5
    var isGroupChat = false
    var userNavImageView = UIImageView()
    var userNameNavLabel = UILabel()
    var messageList: [MockMessage] = []
    var dismissButton : UIButton?
    var isLoadFirst = false
    var hasPrev = false
    
    
    override func viewDidLoad() {
        
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
        messagesCollectionView.register(CustomCell.self)
        
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SBDMain.removeChannelDelegate(forIdentifier: "ChatRoomViewController")
        
        if Utils.getDataFromUserDefault("showAlertOfChatRemoved") != nil {
            Utils.removeDataFromUserDefault("showAlertOfChatRemoved")
        }
    }
    
    func setup()  {
        setupUI()
    }
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            if !self.isLoadFirst {
                self.loadMessagesWithInitial(initial: false)
            }
        }
        refreshControl.endRefreshing()
    }
    
    func chatTableReload(initial:Bool) {
        
        if let dismiss = dismissButton {
            dismiss.removeFromSuperview()
        }
        
        self.messageBaseList = self.messageList
        
        if (self.messageList.count == 0) {
            self.addEmptyAvatarView()
        } else {
            self.isLoadFirst = false
            self.emptyMessageView.removeFromSuperview()
        }
        
        self.messagesCollectionView.reloadData()
        
        if initial {
            self.scrollToBottomAnimated(true)
        }
    }
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 15)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        
        // self(Logged In user avatar image frame)
        layout?.setMessageOutgoingAvatarSize(.zero)
        
        // self(Logged In user Name ex . John doe (me)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(
            textAlignment: .right, textInsets:
            UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 8)))
        
        // self(Logged In user bottom label of message ex. Sent
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(
            textAlignment: .right,
            textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        // Set outgoing avatar to overlap with the message bubble
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(
            textAlignment: .left,
            textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        
        // Avatar image frame
        layout?.setMessageIncomingAvatarSize( ((channel?.members?.count ?? 0) <= 2 && channel?.data != "Group") ? .zero : CGSize(width: 29, height: 29))
        
        // Username label padding ex . John doe
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left:((channel?.members?.count ?? 0) <= 2 && channel?.data != "Group") ? 10 : 18 , bottom: outgoingAvatarOverlap, right: 18))
        
        // Accessory View frame of Other user
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        
        // Accessory View frame of Logged In user
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
    }
    
    override func configureMessageInputBar() {
        super.configureMessageInputBar()
        
        messageInputBar.delegate = self
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.height = 1
        messageInputBar.padding = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 16)
        messageInputBar.inputTextView.tintColor = UIColor.gray
        messageInputBar.inputTextView.backgroundColor =  UIColor.white//UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor.gray
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 9, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor.gray.cgColor
        messageInputBar.inputTextView.textColor = UIColor.gray
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 8.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        configureInputBarItems()
    }
    
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    // MARK: - MessagesDataSource
    
    override func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.Regular(sz: 13), NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        return nil
    }
    
    override func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            /*
             let name = message.sender.displayName
             return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.Regular(sz: 13), NSAttributedString.Key.foregroundColor: UIColor.placeHolder])
             */
            return nil
        }
        return nil
    }
    
    override func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
            let lastSection = messagesCollectionView.numberOfSections - 1
            let lastRowIndex = messagesCollectionView.numberOfItems(inSection: lastSection) - 1
            
            if indexPath.section == lastSection && indexPath.row == lastRowIndex {
                return NSAttributedString(string: "Sent", attributes: [NSAttributedString.Key.font: UIFont.Regular(sz: 12), NSAttributedString.Key.foregroundColor: UIColor.gray])
            } else {
                return nil
            }
        }
        return nil
    }
    
    func reloadData(_ initial: Bool) {
        chatTableReload(initial: initial)
    }
}




//MARK: - Configuare MessageKit
extension ChatRoomViewController {
    
    private func configureInputBarItems() {
        
        // Camera button
        messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: false)
        
        let cameraButton = makeButton(named: "camera")
        cameraButton.isEnabled = true
        cameraButton.isHighlighted = true
        cameraButton.contentEdgeInsets = UIEdgeInsets(top: -6, left: -10, bottom: 6, right: 10)

        //Mark: - AddImage button
        cameraButton.onTouchUpInside { (button) in
            
            if self.channel?.members?.count == 1 {
                Utils.alert(message: "You can not send message because \(self.userName) removed this chat room.")
                return
            }
            self.showCameraPermissionPopup()
        }
        
        let galleryButton = makeButton(named: "gallery")
        galleryButton.isEnabled = true
        galleryButton.isHighlighted = true
        galleryButton.contentEdgeInsets = UIEdgeInsets(top: -6, left: 0, bottom: 6, right: 0)
        //Mark: - AddImage button
        galleryButton.onTouchUpInside { (button) in
            if self.channel?.members?.count == 1 {
                Utils.alert(message: "You can not send message because \(self.userName) removed this chat room.")
                return
            }
            self.showPhotoPermisionPopup()
        }
        
        let leftItems = [galleryButton, cameraButton, .fixedSpace(0)]
        
        messageInputBar.setStackViewItems(leftItems, forStack: .left, animated: false)
        
        // Send button
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor.clear
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 28, height: 35), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "send-Gray")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.isEnabled = true
        messageInputBar.sendButton.backgroundColor = UIColor.clear
        messageInputBar.isTranslucent = false
        messageInputBar.textViewPadding.right = -38
        messageInputBar.maxTextViewHeight = 44
        messageInputBar.separatorLine.height = 1
        messageInputBar.textViewPadding.bottom = 8
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func editBarButtonAction() {
        
        if self.channel?.members?.count == 1 {
            Utils.alert(message: "You can not send message because \(self.userName) removed this chat room.")
            return
        }
        /*
         if self.presenter.channel == nil {
         if let profile = match {
         ChatManager().createGroupChannel(userId: profile.userId, name: profile.name, photoUrl: profile.images?.first?.thumb, completionHandler: {
         [weak self] (channel) in
         guard let self_ = self else { return }
         if (channel != nil) {
         self_.presenter.channel = channel
         self_.channel = channel
         }
         }) { (error) in
         print("SOMETHING WRONG IN CREATE NEW CHANNEL")
         }
         }
         }
         */
        if self.channel == nil {
            createNewChatGroup { (channel) in
                if let chnl = channel {
                    self.channel = chnl
                }
            }
        }
        /*
         let storyBoard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
         if let controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.referFriend) as? ReferFriendListViewController {
         controller.presenter.type = .addParticipant
         controller.delegate = mediator
         controller.presenter.alreadyAvailableIdsForAddParticipate = self.presenter.channel?.members?.value(forKey: "userId") as? [String]
         controller.modalPresentationStyle = .overFullScreen
         navigationController?.present(controller, animated: false, completion: nil)
         }
         */
    }
    
    func createNewChatGroup(handler: @escaping (_ channel: SBDGroupChannel?) -> Void) {
        
        var grpName = ""
        let loggedInUserId = Authorization.shared.profile?.userId ?? ""
        var otherUserId = ""
        var imgUrl = ""
        let loggedInUserName = Authorization.shared.profile?.name ?? ""
        let loggedInUserImg = Authorization.shared.profile?.photo?.thumb ?? ""
        
        if let friend = friendProfile {
            grpName = friend.name + ", " + loggedInUserName
            imgUrl = (friend.images?.first?.thumb ?? "") + "," + loggedInUserImg
            otherUserId = friend.userId
        }
        
        ChatManager().createGroupChannelwithUsers(userIds: [otherUserId,loggedInUserId], groupName: grpName, coverImageUrl: imgUrl, data: "", completionHandler: {
            [weak self] (channel) in
            guard let _ = self else { return }
            DispatchQueue.main
                .async(execute: {
                    // Move on Chat detail screen
                    handler(channel)
                })
            }, errorHandler: {_ in
                print("SOMETHING WRONG IN CREATE NEW CHANNEL")
        })
        
    }
    
    private func showCameraPermissionPopup() {
        
        Utils.authorizeVideo { [unowned self](status) in
            switch status {
            case .alreadyDenied:
                Utils.alertCameraAccessNeeded()
                break
            case .alreadyAuthorized:
                self.openCameraOrLibrary()
                break
            case .restricted:
                Utils.alertCameraAccessNeeded()
                break
            case .justAuthorized:
                self.openCameraOrLibrary()
            case .justDenied:
                break
            }
        }
    }
    
    func openCameraOrLibrary() {
        DispatchQueue.main.async {
            let imagPickerController  = UIImagePickerController()
            if imagPickerController.sourceType == .camera {
                imagPickerController.delegate = self
                imagPickerController.sourceType = .camera
                imagPickerController.allowsEditing = false
                self.navigationController?.present(imagPickerController, animated: true, completion: nil)
            }
        }
    }
    
    
    private func showPhotoPermisionPopup() {
        
        Utils.authorizePhoto { [unowned self] (status) in
            switch status {
            case .justDenied:
                break
            case .alreadyDenied:
                Utils.photoLibraryPermissionAlert()
            case .restricted:
                Utils.photoLibraryPermissionAlert()
            case .justAuthorized:
                self.openPhotoLibrary()
            case .alreadyAuthorized:
                self.openPhotoLibrary()
            }
        }
    }
    
    func openPhotoLibrary() {
        DispatchQueue.main.async {
            let imagPickerController  = UIImagePickerController()
            imagPickerController.delegate = self
            imagPickerController.navigationBar.isTranslucent = false
            imagPickerController.sourceType = .photoLibrary
            imagPickerController.navigationBar.tintColor = UIColor.white
            imagPickerController.navigationBar.barTintColor = UIColor.bgBlack
            imagPickerController.allowsEditing = false
            self.navigationController?.present(imagPickerController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageBaseList[indexPath.section].sender == messageBaseList[indexPath.section - 1].sender
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageBaseList.count else { return false }
        return messageBaseList[indexPath.section].sender == messageBaseList[indexPath.section + 1].sender
    }
    
    func setTypingIndicatorHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        /*
        updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
        setTypingBubbleHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] (_) in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        messagesCollectionView.scrollToBottom(animated: true)
        */
    }
    
    
    
    func insertMessage(_ message: MockMessage) {
        
        self.messageList.append(message)
        self.messageBaseList = self.messageList
        
        if (self.messageList.count == 0) {
            self.addEmptyAvatarView()
        } else {
            self.emptyMessageView.removeFromSuperview()
        }
        
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageBaseList.count - 1])
            if messageBaseList.count >= 2 {
                messagesCollectionView.reloadSections([messageBaseList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 25, height: 25), animated: false)
                $0.tintColor = UIColor.gray83
            }.onSelected {
                $0.tintColor = UIColor.gray83
            }.onDeselected {
                $0.tintColor = UIColor.gray83
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }    
}


// MARK: - Other functions
extension ChatRoomViewController {
    func setupUI() {
        
        updateChannelNameAndImagesOnNav()
        self.perform(#selector(addEmptyAvatarView), with: nil, afterDelay: 1)
        
        
        if let dismiss = dismissButton {
            dismiss.removeFromSuperview()
        }
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        
        SBDMain.add(self as SBDChannelDelegate, identifier: "ChatRoomViewController")

        
        let titleView = UIView(frame: CGRect(0, -7, screenWidth - 100, 48))
        
        userNavImageView = UIImageView(frame: CGRect(x: screenWidth - 115, y: 5, width: 36, height: 36))
        userNavImageView.image = #imageLiteral(resourceName: "bound-add-img")
        userNavImageView.clipsToBounds = true
        userNavImageView.layer.cornerRadius = 18
        userNavImageView.contentMode = .scaleAspectFill
        titleView.addSubview(userNavImageView)
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
        dateLabel.text = "Boris Marshal"
        dateLabel.font = UIFont.DisplayBold(sz: 24)
        dateLabel.textColor = UIColor.white
        
        // View calender button setup
        let viewCalender = UIButton(frame: CGRect(x: 0, y: 27, width: screenWidth - 130, height: 18))
        viewCalender.setTitle("View profile", for: .normal)
        viewCalender.contentHorizontalAlignment = .left
        viewCalender.setTitleColor(UIColor.gray47, for: .normal)
        viewCalender.titleLabel?.font = UIFont.DisplaySemibold(sz: 13)
        titleView.addSubview(dateLabel)
        titleView.addSubview(viewCalender)
        
        navigationItem.titleView = titleView
        
        let leftbarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .done, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = leftbarButton
        
        
        // add gesture
        
        let tap2 = UITapGestureRecognizer(target: self, action:#selector(openGroupMemberList))
        tap2.cancelsTouchesInView = false
        userNavImageView.isUserInteractionEnabled = true
        userNavImageView.addGestureRecognizer(tap2)
        
        if let members = channel?.members {
            if members.count == 2 && channel?.data != "Group" {
                chatType = .single
            } else if members.count == 1 {
                chatType = .single
            } else {
                chatType = .group
                isGroupChat = true
            }
        }
        
        //fetch name and photo
        updateChannelNameAndImagesOnNav()
    }
    
    func updateChannelNameAndImagesOnNav() {
        
        // Show navigation image
        let imageName = updateChatUserImage()
        
        if (self.channel?.members?.count ?? 0) <= 2 {
            showSingleOrGroupPhotos(photoURL: imageName)
        } else {
            //group photo
            showSingleOrGroupPhotos(photoURL: nil)
        }
        
        
        // Show name
        userNameNavLabel.text = self.userName
        
        if (channel?.members?.count ?? 0) == 1 {
            Utils.saveDataToUserDefault(self.userName, "showAlertOfChatRemoved")
        }
    }
    
    @objc func addEmptyAvatarView() {
        if self.messageList.count != 0 {
            return
        }
        emptyMessageView.removeFromSuperview()
        if let dismiss = dismissButton {
            dismiss.removeFromSuperview()
        }
        
        emptyMessageView = UIView(frame: self.view.bounds)
        
        emptyUserImageView = UIImageView(frame: CGRect((screenWidth/2) - 44, (screenHeight/2) - 44, 88, 88))
        emptyUserImageView.clipsToBounds = true
        emptyUserImageView.image = #imageLiteral(resourceName: "grayChat")
        emptyUserImageView.contentMode = .scaleAspectFill
        emptyUserImageView.layer.cornerRadius = 44
        emptyMessageView.addSubview(emptyUserImageView)
        
        var timeLabel = UILabel()
        timeLabel = UILabel(frame: CGRect(x: 16, y: (screenHeight/2) + 60, width: screenWidth - 32 , height: 22))
        timeLabel.font = UIFont.Semibold(sz: 17)
        timeLabel.numberOfLines = 0
        timeLabel.textColor = UIColor.buttonDisableTextColor
        timeLabel.textAlignment = .center
        timeLabel.isUserInteractionEnabled = false
        timeLabel.text = String(format: emptyMessageFriendTitle, self.userName)
        emptyMessageView.addSubview(timeLabel)
        
        view.addSubview(emptyMessageView)
        
        dismissButton = UIButton(frame: self.view.frame)
        dismissButton?.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        dismissButton?.setTitle("", for: .normal)
        self.view.addSubview(dismissButton!)
        
        if friendProfile != nil {
            if channel != nil {
                let img = friendProfile?.images?.first?.thumb ?? ""
//                emptyUserImageView.sd_setImage(with: URL(string: img), completed: nil)
                updateChannelNameAndImagesOnNav()
            } else {
                let img = friendProfile?.images?.first?.thumb ?? ""
//                emptyUserImageView.sd_setImage(with: URL(string: img), completed: nil)
                
                userNameNavLabel.text = friendProfile?.name ?? ""
                let imgUser = friendProfile?.images?.first?.thumb ?? ""
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
//                emptyUserImageView.sd_setImage(with: URL(string: updateChatUserImage()), completed: nil)
            } else {
//                emptyUserImageView.sd_setImage(with: URL(string: imgName), completed: nil)
            }
            userNameNavLabel.text = self.userName
            showSingleOrGroupPhotos(photoURL: updateChatUserImage())
        }
    }
    
    func showSingleOrGroupPhotos(photoURL:String?) {
        if let photo = photoURL {
            if self.channel == nil || (self.channel?.members?.count ?? 0) <= 2 {
                //single photo
                userNavImageView.isHidden = false
//                userNavImageView.sd_setImage(with: URL(string: photo), completed: nil)
            }
        }
    }
    
    private func updateChatUserImage() -> String {
        
        var imageName = ""
        if self.channel != nil {
            if let members = self.channel?.members {
                _ = Array<NSURL>()
                if members.count == 2 && self.channel?.data != "Group" {
                    for member in members {
                        if let user = member as? SBDUser {
                            let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                            if loggedInUserId != user.userId {
                                imageName = user.profileUrl ?? ""
                                self.userName = user.nickname ?? ""
                            }
                        }
                    }
                } else if members.count == 1 {
                    self.userName = Utils.onlyDisplayFirstNameOrLastNameFirstCharacter(Utils.removeLoginUserNameFromChannel(channelName: self.channel?.name ?? ""))
                    
                    if let url = self.channel?.coverUrl, url.isNotEmpty {
                        let images = url.components(separatedBy: ",")
                        for image in images {
                            if image != Authorization.shared.profile?.photo?.thumb {
                                imageName = image
                            }
                        }
                    }
                } else {
                    
                    var chatName = ChatManager().getChatName(self.channel)
                    chatName = Utils.onlyDisplayFirstNameOrLastNameFirstCharacter(chatName)
                    self.userName = chatName
                    
                    if let url = self.channel?.coverUrl {
                        /*
                         let images = url.components(separatedBy: ",")
                         
                         for image in images {
                         urls.append(NSURL(string: image)!)
                         }
                         */
                        imageName = url
                    }
                }
            }
        } else if let frnd = friendProfile {
            imageName = frnd.images?.first?.thumb ?? ""
            userName = frnd.name
        }
        return imageName
    }
    
    @objc func openGroupMemberList() {
        
    }
}
