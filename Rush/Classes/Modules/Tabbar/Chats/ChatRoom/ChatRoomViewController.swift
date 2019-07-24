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
    var userNavGroupView = UIView()
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
        
//        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navigationBar.pdf").resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: UIBarMetrics.default)
        
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
        messageInputBar.setLeftStackViewWidthConstant(to: 60, animated: false)
        
        let cameraButton = makeButton(named: "camera-blue")
        cameraButton.isEnabled = true
        cameraButton.isHighlighted = true
        cameraButton.contentEdgeInsets = UIEdgeInsets(top: -6, left: 0, bottom: 6, right: 0)
        let leftItems = [cameraButton, .fixedSpace(0)]
        //Mark: - AddImage button
        cameraButton.onTouchUpInside { (button) in
            
            if self.channel?.members?.count == 1 {
                Utils.alert(message: "You can not send message because \(self.userName) removed this chat room.")
                return
            }
            
            Utils.alert(message: nil, title: nil, buttons: ["Take photo", "Upload photo"], cancel : "Cancel", destructive: nil, type: .actionSheet) {
                [weak self] (index) in
                guard let self_ = self else { return }
                if index == 0 {
                    self_.showCameraPermissionPopup()
                }
                else if index == 1 {
                    self_.showPhotoPermisionPopup()
                }
            }
        }
        messageInputBar.setStackViewItems(leftItems, forStack: .left, animated: false)
        
        // Send button
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor.clear
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 28, height: 35), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "send-grey")
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
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            NSLog("cameraAuthorizationStatus=denied")
            self.alertCameraAccessNeeded()
            break
        case .authorized:
            NSLog("cameraAuthorizationStatus=authorized")
            openCameraOrLibrary()
            break
        case .restricted:
            NSLog("cameraAuthorizationStatus=restricted")
            self.alertCameraAccessNeeded()
            break
        case .notDetermined:
            NSLog("cameraAuthorizationStatus=notDetermined")
            
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        // do something
                        self.openCameraOrLibrary()
                    } else {
                        // do something else
                    }
                }
            }
        }
    }
    
    func openCameraOrLibrary() {
        DispatchQueue.main.async {
            let imagPickerController  = UIImagePickerController()
            imagPickerController.delegate = self
            imagPickerController.sourceType = .camera
            imagPickerController.allowsEditing = false
            self.navigationController?.present(imagPickerController, animated: true, completion: nil)
        }
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Camera Access",
            message: "We wants to use camera to capture image.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertPhotoAccessNeeded() {
        
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Photo Library Access",
            message: "Allow user to choose photo from gallery and load from library.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showPhotoPermisionPopup() {
        let photos = PHPhotoLibrary.authorizationStatus()
        
        switch photos {
        case .denied:
            NSLog("cameraAuthorizationStatus=denied")
            self.alertPhotoAccessNeeded()
            break
        case .authorized:
            NSLog("cameraAuthorizationStatus=authorized")
            openPhotoLibrary()
            break
        case .restricted:
            NSLog("cameraAuthorizationStatus=restricted")
            self.alertPhotoAccessNeeded()
            break
        case .notDetermined:
            NSLog("cameraAuthorizationStatus=notDetermined")
            
            // Prompting user for the permission to use the photo.
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.openPhotoLibrary()
                    }
                } else {
                    
                }
            })
        }
    }
    
    func openPhotoLibrary() {
        DispatchQueue.main.async {
            let imagPickerController  = UIImagePickerController()
            imagPickerController.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navigationBar.pdf").resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: UIBarMetrics.default)
            imagPickerController.delegate = self
            imagPickerController.sourceType = .photoLibrary
            imagPickerController.navigationBar.tintColor = UIColor.white
            imagPickerController.navigationBar.barTintColor = UIColor.blue
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
        //        updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
        //        setTypingBubbleHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] (_) in
        //            if self?.isLastSectionVisible() == true {
        //                self?.messagesCollectionView.scrollToBottom(animated: true)
        //            }
        //        }
        //        messagesCollectionView.scrollToBottom(animated: true)
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
                $0.tintColor = UIColor.blue
            }.onSelected {
                $0.tintColor = UIColor.red
            }.onDeselected {
                $0.tintColor = UIColor.gray47
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
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
        // MainView
        let userView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 150, height: 44))
        
        // BackView
        let backView = UIButton(frame: CGRect(x: 0, y: 8, width: 28, height: 28))
        let back = UIImage(named: "back-White")?.withRenderingMode(.alwaysTemplate)
        backView.setImage(back, for: .normal)
        backView.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backView.tintColor = UIColor.white
        
        // Group member list button
        let groupView = UIButton(frame: CGRect(x: 36, y: 0, width: screenWidth - 150 - 36, height: 28))
        groupView.addTarget(self, action: #selector(openGroupMemberList), for: .touchUpInside)
        
        userNavImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        userNavImageView.backgroundColor = UIColor.black
        userNavImageView.clipsToBounds = true
        userNavImageView.layer.cornerRadius = 19
        userNavImageView.contentMode = .scaleAspectFill
        groupView.addSubview(userNavImageView)
        
        
        userNavGroupView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        userNavGroupView.backgroundColor = UIColor.clear
        userNavGroupView.clipsToBounds = true
        
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        imageView1.backgroundColor = UIColor.purple
        imageView1.clipsToBounds = true
        imageView1.tag = 1001
        imageView1.layer.cornerRadius = 14
        imageView1.contentMode = .scaleAspectFill
        userNavGroupView.addSubview(imageView1)
        
        let imageView2 = UIImageView(frame: CGRect(x: 10, y: 9, width: 28, height: 28))
        imageView2.backgroundColor = UIColor.purple
        imageView2.clipsToBounds = true
        imageView2.tag = 1002
        imageView2.layer.cornerRadius = 14
        imageView2.contentMode = .scaleAspectFill
        userNavGroupView.addSubview(imageView2)
        userNavGroupView.isHidden = true
        groupView.addSubview(userNavGroupView)
        
        // UserName
        userNameNavLabel = UILabel(frame: CGRect(x: 46, y: 0, width: screenWidth - 150 , height: 38))
        userNameNavLabel.font = UIFont.Semibold(sz: 17)
        userNameNavLabel.textColor = UIColor.white
        
        userView.addSubview(backView)
        groupView.addSubview(userNameNavLabel)
        userView.addSubview(groupView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userView)
        
        let editBarButton = UIBarButtonItem(image: UIImage(named: "addMember-white"), style: .done, target: self, action: #selector(editBarButtonAction))
        navigationItem.rightBarButtonItem = editBarButton
        
        // add gesture
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(openGroupMemberList))
        tap1.cancelsTouchesInView = false
        userNavGroupView.addGestureRecognizer(tap1)
        
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
        
        /*
         if isFromMatch {
         //add empty avatarview
         addEmptyAvatarView()
         }
         */
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
        
        let topY = screenHeight*0.3
        let outerHeight : CGFloat = 192
        
        let outerView = UIView(frame: CGRect(0, topY, 192, outerHeight))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 15
        outerView.isUserInteractionEnabled = false
        outerView.center.x = view.center.x
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 192/2).cgPath
        
        emptyUserImageView = UIImageView(frame: outerView.bounds)
        emptyUserImageView.clipsToBounds = true
        emptyUserImageView.contentMode = .scaleAspectFill
        emptyUserImageView.layer.cornerRadius = 192/2
        
        outerView.addSubview(emptyUserImageView)
        emptyMessageView.addSubview(outerView)
        
        // time
        let heightTime : CGFloat = 58
        
        var timeLabel = UILabel()
        
        if isFromMatch {
            timeLabel = UILabel(frame: CGRect(x: 16, y: topY + outerHeight + 24/* Padding */, width: screenWidth - 32 , height: heightTime))
        } else {
            timeLabel = UILabel(frame: CGRect(x: 16, y: topY + outerHeight + 24/* Padding */, width: screenWidth - 32 , height: 130))
        }
        
        timeLabel.font = UIFont.DisplaySemibold(sz: 24)
        timeLabel.numberOfLines = 0
        timeLabel.textColor = UIColor.green
        timeLabel.textAlignment = .center
        timeLabel.isUserInteractionEnabled = false
        
        
        if channel != nil {
            timeLabel.text = String(format: emptyMessageFriendTitle, self.userName)
        } else {
            timeLabel.text = String(format: emptyMessageFriendTitle, friendProfile?.name ?? self.userName)
        }
        
        
        emptyMessageView.addSubview(timeLabel)
        
        if emptyMessageType == .beginner && isFromMatch {
            // detail
            let detailLabel = UILabel(frame: CGRect(x: 30, y: topY + outerHeight + heightTime + 32/* Padding */, width: screenWidth - 60 , height: 44))
            detailLabel.font = UIFont.Regular(sz: 17)
            detailLabel.numberOfLines = 0
            detailLabel.textColor = UIColor.blue
            detailLabel.textAlignment = .center
            detailLabel.text = "You two matched for a reason. Say something!"
            emptyMessageView.addSubview(detailLabel)
        }
        view.addSubview(emptyMessageView)
        
        dismissButton = UIButton(frame: self.view.frame)
        dismissButton?.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        dismissButton?.setTitle("", for: .normal)
        self.view.addSubview(dismissButton!)
        
        if friendProfile != nil {
            if channel != nil {
                let img = friendProfile?.images?.first?.thumb ?? ""
                emptyUserImageView.sd_setImage(with: URL(string: img), completed: nil)
                updateChannelNameAndImagesOnNav()
            } else {
                let img = friendProfile?.images?.first?.thumb ?? ""
                emptyUserImageView.sd_setImage(with: URL(string: img), completed: nil)
                
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
                emptyUserImageView.sd_setImage(with: URL(string: updateChatUserImage()), completed: nil)
            } else {
                emptyUserImageView.sd_setImage(with: URL(string: imgName), completed: nil)
            }
            userNameNavLabel.text = self.userName
            showSingleOrGroupPhotos(photoURL: updateChatUserImage())
        }
    }
    
    func showSingleOrGroupPhotos(photoURL:String?) {
        userNavGroupView.isHidden = true
        
        if let photo = photoURL {
            if self.channel == nil || (self.channel?.members?.count ?? 0) <= 2 {
                //single photo
                userNavGroupView.isHidden = true
                userNavImageView.isHidden = false
                userNavImageView.sd_setImage(with: URL(string: photo), completed: nil)
            } else {
                showGroupPhotos()
            }
            
        } else {//group photo
            showGroupPhotos()
        }
    }
    
    func showGroupPhotos() {
        if let members = self.channel?.members {
            
            userNavGroupView.isHidden = false
            userNavImageView.isHidden = true
            
            let imageView1 =  userNavGroupView.viewWithTag(1001) as! UIImageView
            let imageView2 =  userNavGroupView.viewWithTag(1002) as! UIImageView
            
            
            var i = 0
            for member in members {
                if let user = member as? SBDUser {
                    if user.userId != Authorization.shared.profile?.userId {
                        if i == 0 {
                            imageView1.sd_setImage(with: URL(string: user.profileUrl ?? ""), completed: nil)
                            i += 1;
                        } else {
                            imageView2.sd_setImage(with: URL(string: user.profileUrl ?? ""), completed: nil)
                        }
                    }
                }
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
