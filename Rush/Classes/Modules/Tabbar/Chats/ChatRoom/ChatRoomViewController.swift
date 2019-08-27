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

enum ChatType : Int {
    case single = 0
    case group = 1
}

class ChatRoomViewController: MessagesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let outgoingAvatarOverlap: CGFloat = 17.5
    var userNavImageView = UIImageView()
    var userNameNavLabel = UILabel()
    var timeLabel = UILabel()
    var messageList: [MockMessage] = []
    var dismissButton : UIButton?
    var isLoadFirst = false
    var hasPrev = false
    var isShowTempData = false
    var isAllowTestMessage = false
    var friendProfile: Profile?
    var channel : SBDGroupChannel?
    var chatType : ChatType = .single
    open var previousMessageQuery : SBDPreviousMessageListQuery?
    var emptyMessageView = UIView()
    var emptyUserImageView = UIImageView()
    var emptyMessageFriendTitle = "This is a beginning of you chat history."
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if isShowTempData {
            MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
                .onNewMessage { [weak self] message in
                    self?.insertMessages(message)
            }
        }
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MockSocket.shared.disconnect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SBDMain.removeChannelDelegate(forIdentifier: "ChatRoomViewController")
        if Utils.getDataFromUserDefault("showAlertOfChatRemoved") != nil {
            Utils.removeDataFromUserDefault("showAlertOfChatRemoved")
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
    
    func setup()  {
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
    
    func insertMessages(_ message: MockMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
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
    }
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getMessages(count: 20, isGroupChat: self.isGroupChat) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
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
    
    func chatTableReload(initial:Bool) {
        
        if (messageList.count == 0) {
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
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left:((channel?.members?.count ?? 0) <= 2 && channel?.data != "Group") ? 18 : 18 , bottom: outgoingAvatarOverlap, right: 18))
        
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
        
        //Mark: - AddImage button
        cameraButton.onTouchUpInside { (button) in
            if self.channel?.members?.count == 1 {
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
        
        SBDMain.add(self as SBDChannelDelegate, identifier: "ChatRoomViewController")
        
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
    
    func emptyPlaceholderView(isHide: Bool) {
        emptyMessageView.isHidden = isHide
        emptyUserImageView.isHidden = isHide
        dismissButton?.isHidden = isHide
        timeLabel.isHidden = isHide
        messagesCollectionView.reloadData()
    }
    
    func setupNavigation() {
        let titleView = UIView(frame: CGRect(0, -7, screenWidth - 100, 48))
        
        userNavImageView = UIImageView(frame: CGRect(x: screenWidth - 115, y: 5, width: 36, height: 36))
        userNavImageView.image = #imageLiteral(resourceName: "bound-add-img")
        userNavImageView.clipsToBounds = true
        userNavImageView.layer.cornerRadius = 18
        userNavImageView.contentMode = .scaleAspectFill
        titleView.addSubview(userNavImageView)
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
        dateLabel.text = userName
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
    }
    
    @objc func setupPlaceholderView() {
        
        emptyMessageView = UIView(frame: self.view.bounds)
        emptyUserImageView = UIImageView(frame: CGRect((screenWidth/2) - 44, (screenHeight/2) - 44, 88, 88))
        emptyUserImageView.clipsToBounds = true
        emptyUserImageView.image = #imageLiteral(resourceName: "grayChat")
        emptyUserImageView.contentMode = .scaleAspectFill
        emptyUserImageView.layer.cornerRadius = 44
        emptyMessageView.addSubview(emptyUserImageView)
        
        timeLabel = UILabel()
        timeLabel = UILabel(frame: CGRect(x: 16, y: (screenHeight/2) + 60, width: screenWidth - 32 , height: 22))
        timeLabel.font = UIFont.Semibold(sz: 17)
        timeLabel.numberOfLines = 0
        timeLabel.textColor = UIColor.buttonDisableTextColor
        timeLabel.textAlignment = .center
        timeLabel.isUserInteractionEnabled = false
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.2
        timeLabel.text = String(format: emptyMessageFriendTitle, self.userName)
        emptyMessageView.addSubview(timeLabel)
        view.addSubview(emptyMessageView)
        
        dismissButton = UIButton(frame: self.view.frame)
        dismissButton?.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        dismissButton?.setTitle("", for: .normal)
        self.view.addSubview(dismissButton!)
    }
    
    func scrollToBottomAnimated(_ animated: Bool) {
        if messageList.count > 0 {
            messagesCollectionView.scrollToBottom(animated: animated)
        }
    }
}
