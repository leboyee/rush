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

enum ChatType: Int {
    case single = 0
    case group = 1
}

class ChatRoomViewController: MessagesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let outgoingAvatarOverlap: CGFloat = 17.5
    var userNavImageView = UIImageView()
    var userNavImage: UIImage?
    var userNameNavLabel = UILabel()
    var timeLabel = UILabel()
    var messageList: [MockMessage] = []
    var dismissButton: UIButton?
    var isLoadFirst = false
    var hasPrev = false
    var isShowTempData = false
    var isAllowTestMessage = false
    
    var channel: SBDGroupChannel?
    var chatType: ChatType = .single
    var chatDetailType: ChatDetailType = .single
    
    var friendProfile: Friend?
    var clubInfo: Club?
    var eventInfo: Event?
    var subclassInfo: SubClass?
    var rosterArray: [Invitee]?
    
    var profileUserId = ""
    
    open var previousMessageQuery: SBDPreviousMessageListQuery?
    
    var emptyMessageView = UIView()
    var emptyUserImageView = UIImageView()
    var emptyMessageFriendTitle = " This is the beginning of your chat history"
    var userName = ""
    let refreshControl = UIRefreshControl()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
        messagesCollectionView.register(CustomCell.self)
        messagesCollectionView.register(EventMessageCell.self)
        
        super.viewDidLoad()
        setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MockSocket.shared.disconnect()
        //Set unread count
        ChatManager().getUnreadCount({ (count) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateUnreadcount), object: (count))
            Utils.saveDataToUserDefault(count, kUnreadChatMessageCount)
        })
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SBDMain.removeChannelDelegate(forIdentifier: ViewControllerId.chatRoomViewController)
        if Utils.getDataFromUserDefault(UserDefaultKey.showAlertOfChatRemoved) != nil {
            Utils.removeDataFromUserDefault(UserDefaultKey.showAlertOfChatRemoved)
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
         if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func setup() {
        if isShowTempData {
            loadFirstMessages()
        }
        configureMessageCollectionView()
        configureMessageInputBar()
        
        updateChannelNameAndImagesOnNav()
        setupPlaceholderView()
        setupNavigation()
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
              
        setupUI()
    }
    
    // MARK: - Helpers
    func isLastSectionVisible() -> Bool {
        guard !messageList.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    //===========================================================================
    // Test
    func loadFirstMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let count = UserDefaults.standard.mockMessagesCount()
            SampleData.shared.getMessages(count: count, isGroupChat: self.isGroupChat) { messages in
                DispatchQueue.main.async {
                    self.messageList = messages
                    self.chatTableReload(initial: true)
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
    }
    
    @objc func loadMoreMessages() {
        self.loadMessagesWithInitial(initial: false)
        self.refreshControl.endRefreshing()
        /*
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getMessages(count: 20, isGroupChat: self.isGroupChat) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
        */
    }
    //===========================================================================
    
    /*
     @objc func loadMoreMessages() {
     DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
     if !self.isLoadFirst {
     self.loadMessagesWithInitial(initial: false)
     }
     }
     refreshControl.endRefreshing()
     }
     */
    
    func chatTableReload(initial: Bool) {
        if messageList.count == 0 {
            emptyPlaceholderView(isHide: false)
        } else {
            emptyPlaceholderView(isHide: true)
            isLoadFirst = false
        }
        
        messagesCollectionView.reloadData()
        
        if initial {
            scrollToBottomAnimated(true)
        }
    }
    
    func reloadData(_ initial: Bool) {
        chatTableReload(initial: initial)
    }
}

// MARK: - Chat configration
extension ChatRoomViewController {
    func configureMessageCollectionView() {
        
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
        layout?.setMessageIncomingAvatarSize( ((channel?.members?.count ?? 0) <= 2 && channel?.data != "Group") ? CGSize(width: 29, height: 29) : CGSize(width: 29, height: 29))
        
        // Username label padding ex . John doe
        let count = channel?.members?.count ?? 0
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: (count <= 2 && channel?.data != "Group") ? 18 : 18, bottom: outgoingAvatarOverlap, right: 18))
        
        // Accessory View frame of Other user
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        
        // Accessory View frame of Logged In user
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messagesCollectionView.messagesDataSource = self
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
    }
    
    func configureMessageInputBar() {
        messageInputBar.backgroundColor = UIColor.clear
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.sendButton.tintColor = .primaryColor
        
        messageInputBar.delegate = self
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.height = 1
        messageInputBar.padding = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 16)
        messageInputBar.inputTextView.tintColor = UIColor.brown24
        messageInputBar.inputTextView.backgroundColor =  UIColor.white
        messageInputBar.inputTextView.placeholderTextColor = UIColor.buttonDisableTextColor
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 9, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 36)
        messageInputBar.inputTextView.textColor = UIColor.bgBlack
        messageInputBar.inputTextView.backgroundColor = UIColor.lightGray93
        messageInputBar.inputTextView.layer.cornerRadius = 17
        //        messageInputBar.inputTextView.clipsToBounds = true
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        // Camera button
        messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 57, animated: false)
        
        let cameraButton = makeButton(named: "camera")
        cameraButton.isEnabled = true
        cameraButton.isHighlighted = true
        cameraButton.contentEdgeInsets = UIEdgeInsets(top: -6, left: -10, bottom: 6, right: 10)
        
        // MARK: - AddImage button
        cameraButton.onTouchUpInside { (_) in
            
            if self.channel?.customType == "single" && self.channel?.members?.count == 1 {
                Utils.alert(message: "You can not send message because \(self.userName) removed this chat room.")
                return
            }
            self.showCameraPermissionPopup()
        }
        
        // Gallery button
        let galleryButton = makeButton(named: "gallery")
        galleryButton.isEnabled = true
        galleryButton.isHighlighted = true
        galleryButton.contentEdgeInsets = UIEdgeInsets(top: -6, left: 0, bottom: 6, right: 0)
        
        // MARK: - AddGallryImage button
        galleryButton.onTouchUpInside { (_) in
            if self.channel?.customType == "single" && self.channel?.members?.count == 1 {
                Utils.alert(message: "You can not send message because \(self.userName) removed this chat room.")
                return
            }
            self.showPhotoPermisionPopup()
        }
        
        let leftItems = [galleryButton, cameraButton, .fixedSpace(0)]
        
        messageInputBar.setStackViewItems(leftItems, forStack: .left, animated: false)
        
        // Send button
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor.clear
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: -50)
        messageInputBar.sendButton.setSize(CGSize(width: 28, height: 35), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "send-Gray")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.isEnabled = true
        messageInputBar.sendButton.backgroundColor = UIColor.clear
        messageInputBar.isTranslucent = false
        messageInputBar.textViewPadding.right = -30
        messageInputBar.maxTextViewHeight = 44
        messageInputBar.separatorLine.height = 1
        messageInputBar.textViewPadding.bottom = 8
    }
}

// MARK: - Actions
extension ChatRoomViewController {
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func editBarButtonAction() {
        
        if self.channel?.customType == "single" && self.channel?.members?.count == 1 {
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
      
        SBDMain.add(self as SBDChannelDelegate, identifier: "ChatRoomViewController")
        
        if self.channel == nil {
            createNewChatGroup { (channel) in
                if let chnl = channel {
                    self.channel = chnl
                    DispatchQueue.main.async {
                        self.setupUI()
                    }
                }
            }
        }
        
        if channel?.customType == "single" {
            chatType = .single
        } else {
            chatType = .group
            
            if let members = channel?.members as? [SBDUser] {
                userChatView.reloadData(users: members)
                userChatView.showAllUserClickEvent = { () in
                    
                    var users = [String: Any]()
                    
                    for member in members {
                        if let first = member.nickname?.first {
                            if let value = users[first.description.lowercased()]  as? [Friend] {
                                let filter = value.filter { $0.user?.userId == member.userId }
                                if filter.count == 0 {
                                    var tempUser = [Friend]()
                                    tempUser.append(contentsOf: value)
                                    
                                    let friend = Friend()
                                    let user = User()
                                    user.firstName = member.nickname ?? ""
                                    user.id = Int64(member.userId) ?? 0
                                    user.photoJson = "{\"main\":{\"url\":\"\(member.profileUrl ?? "")\"},\"thumb\":{\"url\":\"\(member.profileUrl ?? "")\"}}"
                                    friend.user = user
                                    
                                    tempUser.append(friend)
                                    users[first.description.lowercased()] = tempUser
                                }
                            } else {
                                let friend = Friend()
                                let user = User()
                                user.firstName = member.nickname ?? ""
                                user.id = Int64(member.userId) ?? 0
                                user.gender = member.profileUrl
                                user.photoJson = "{\"main\":{\"url\":\"\(member.profileUrl ?? "")\"},\"thumb\":{\"url\":\"\(member.profileUrl ?? "")\"}}"
                                friend.user = user
                                users[first.description.lowercased()] = [friend]
                            }
                        }
                    }
                    
                    let storyboard = UIStoryboard(name: StoryBoard.chat, bundle: nil)
                    if let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerId.chatContactsList) as? ChatContactsListViewController {
                        vc.friendsList = users
                        vc.isFromChat = true
                        vc.titleName = self.userName
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
        //fetch name and photo
        updateChannelNameAndImagesOnNav()
        
        //Load data
        loadPrevisouMessages()
        
        // Read all message from this channel
        readAllMessages()
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > 0, keyboardSize.height < 150 {
            emptyUserImageView.frame =  CGRect(x: (screenWidth/2) - 44, y: isGroupChat ? 200 : 152, width: 88, height: 88)
            timeLabel.frame = CGRect(x: 16, y: isGroupChat ? 300 : 256, width: screenWidth - 32, height: 22)
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardSize.height > 0 {
            emptyUserImageView.frame =  CGRect(x: (screenWidth/2) - 44, y: (screenHeight/2) - 44, width: 88, height: 88)
            timeLabel.frame = CGRect(x: 16, y: (screenHeight/2) + 60, width: screenWidth - 32, height: 22)
        }
    }
    
    func updateChannelNameAndImagesOnNav() {
        
        // Show navigation image
        let imageName = updateChatUserImage()
        
        userNavImageView.sd_setImage(with: URL(string: imageName)) { (_, error, _, _) in
            if error != nil {
                self.userNavImageView.image = UIImage(named: "placeholder-profile-48px")
            }
        }
        // Show name
        var nm = self.userName
        nm = nm.replacingOccurrences(of: ", ", with: "")
        nm = nm.replacingOccurrences(of: ",", with: "")
        userNameNavLabel.text = nm
        
        /*
         if (self.channel?.members?.count ?? 0) <= 2 {
         showSingleOrGroupPhotos(photoURL: imageName)
         } else {
         //group photo
         showSingleOrGroupPhotos(photoURL: nil)
         }
         */
        
        if (channel?.members?.count ?? 0) == 1 && channel?.customType == "single" {
            Utils.saveDataToUserDefault(self.userName, UserDefaultKey.showAlertOfChatRemoved)
        }
    }
    
    func emptyPlaceholderView(isHide: Bool) {
        emptyMessageView.isHidden = isHide
        emptyUserImageView.isHidden = isHide
        dismissButton?.isHidden = isHide
        timeLabel.isHidden = isHide
        messagesCollectionView.reloadData()
    }
    
    func setupNavigation() {
        let titleView = UIView(frame: CGRect(0, -7, screenWidth, 48))
        
        userNavImageView = UIImageView(frame: CGRect(x: screenWidth - 115, y: 5, width: 36, height: 36))
        if friendProfile != nil {
            userNavImageView.sd_setImage(with: friendProfile?.user?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeHolderIcon"))
        } else if clubInfo != nil {
            userNavImageView.sd_setImage(with: clubInfo?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-club48px"))
        } else if eventInfo != nil {
            userNavImageView.sd_setImage(with: eventInfo?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-event48px"))
        } else if userNavImage != nil {
            userNavImageView.image = userNavImage
            
            if userNavImage == nil {
                userNavImageView.image = UIImage(named: "placeholder-profile-48px")
            }
        }
        
        userNavImageView.clipsToBounds = true
        userNavImageView.layer.cornerRadius = 18
        userNavImageView.contentMode = .scaleAspectFill
        titleView.addSubview(userNavImageView)
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
        dateLabel.text = userName
        dateLabel.font = UIFont.displayBold(sz: 24)
        dateLabel.textColor = UIColor.white
        
        // View calender button setup
        let detailButton = UIButton(frame: CGRect(x: 0, y: -7, width: screenWidth, height: 48))
//        detailButton.backgroundColor = UIColor.yellow
        let viewCalender = UIButton(frame: CGRect(x: 0, y: 27, width: screenWidth - 130, height: 18))
        if clubInfo != nil || channel?.customType == "club" {
            viewCalender.setTitle("View club details", for: .normal)
        } else  if eventInfo != nil || channel?.customType == "event" {
            viewCalender.setTitle("View event details", for: .normal)
        } else if subclassInfo != nil || channel?.customType == "class" {
            viewCalender.setTitle("View class details", for: .normal)
        } else {
            viewCalender.setTitle("View profile", for: .normal)
        }
        viewCalender.contentHorizontalAlignment = .left
        viewCalender.setTitleColor(UIColor.gray47, for: .normal)
        viewCalender.titleLabel?.font = UIFont.displaySemibold(sz: 13)
        
        detailButton.addTarget(self, action: #selector(openUserProfileScreen), for: .touchUpInside)
        
        titleView.addSubview(dateLabel)
        titleView.addSubview(viewCalender)
        titleView.addSubview(detailButton)
        
        navigationItem.titleView = titleView
        
        let leftbarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .done, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = leftbarButton
    }
    
    @objc func setupPlaceholderView() {
        
        //        emptyMessageView = UIView(frame: self.view.bounds)
        emptyUserImageView = UIImageView(frame: CGRect((screenWidth/2) - 44, (screenHeight/2) - 44, 88, 88))
        emptyUserImageView.clipsToBounds = true
        emptyUserImageView.image = #imageLiteral(resourceName: "grayChat")
        emptyUserImageView.contentMode = .scaleAspectFill
        emptyUserImageView.layer.cornerRadius = 44
        view.addSubview(emptyUserImageView)
        
        timeLabel = UILabel()
        timeLabel = UILabel(frame: CGRect(x: 16, y: (screenHeight/2) + 60, width: screenWidth - 32, height: 22))
        timeLabel.font = UIFont.semibold(sz: 17)
        timeLabel.numberOfLines = 0
        timeLabel.textColor = UIColor.buttonDisableTextColor
        timeLabel.textAlignment = .center
        timeLabel.isUserInteractionEnabled = false
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.2
        timeLabel.text = String(format: emptyMessageFriendTitle, self.userName)
        view.addSubview(timeLabel)
        //        view.addSubview(emptyMessageView)
        
        dismissButton = UIButton(frame: CGRect(x: 0, y: isGroupChat ? 180 : 108, width: screenWidth, height: screenHeight - (isGroupChat ? 180 : 108)))
        dismissButton?.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        dismissButton?.setTitle("", for: .normal)
        self.view.addSubview(dismissButton!)
    }
    
    func scrollToBottomAnimated(_ animated: Bool) {
        if messageList.count > 0 {
            messagesCollectionView.scrollToBottom(animated: animated)
        }
    }
    
    @objc func openUserProfileScreen() {
        
        if clubInfo != nil || channel?.customType == "club" {
            let storyboard = UIStoryboard(name: StoryBoard.home, bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerId.clubDetailViewController) as? ClubDetailViewController else { return }
            if clubInfo != nil {
                controller.clubInfo = clubInfo
            } else {
                let club = Club()
                club.id = Int64(channel?.data ?? "0") ?? 0
                controller.clubInfo = club
                controller.isFromChatDetail = true
            }
            self.navigationController?.pushViewController(controller, animated: true)
        } else if eventInfo != nil || channel?.customType == "event" {
            if eventInfo != nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                let storyboard = UIStoryboard(name: StoryBoard.eventDetail, bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerId.eventDetailViewController) as? EventDetailViewController else { return }
                controller.eventId = channel?.data ?? "0"
                controller.isFromChatDetail = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else if subclassInfo != nil || channel?.customType == "class" {
            if subclassInfo != nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                let storyboard = UIStoryboard(name: StoryBoard.home, bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerId.classDetail) as? ClassDetailViewController else { return }
                controller.classId = channel?.data ?? "0"
                controller.isFromChatDetail = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let storyboard = UIStoryboard(name: StoryBoard.home, bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerId.otherUserProfileController) as? OtherUserProfileController else { return }
            if let friend = friendProfile {
                controller.userInfo = friend.user
            } else if profileUserId.isNotEmpty {
                let user = User()
                user.id = Int64(profileUserId) ?? 0
                controller.userInfo = user
            } else if let id = channel?.data {
                let user = User()
                user.id = Int64(id) ?? 0
                controller.userInfo = user
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
