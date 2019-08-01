//
//  ChatRoomMediator.swift
//  Friends
//
//  Created by iChirag on 28/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit
import SendBirdSDK

// MARK: - MessagesDisplayDelegate
extension ChatRoomViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.bgBlack : UIColor.bgBlack
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.white : UIColor.lightGray93
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if chatType == .group {
            let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
            avatarView.set(avatar: avatar)
            avatarView.isHidden = isNextMessageSameSender(at: indexPath)
            avatarView.backgroundColor = UIColor.bgBlack17
        } else {
//            avatarView.isHidden = true
//            avatarView.frame = CGRect.zero
            let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
            avatarView.set(avatar: avatar)
            avatarView.isHidden = isNextMessageSameSender(at: indexPath)
            avatarView.backgroundColor = UIColor.bgBlack17
        }
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        guard accessoryView.subviews.isEmpty else { return }
        let button = UIButton(type: .infoLight)
        button.tintColor = .primaryColor
        accessoryView.addSubview(button)
        button.frame = accessoryView.bounds
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        accessoryView.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.3)
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatRoomViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? (isGroupChat ? 20 : 0) : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? ((isGroupChat ? 20 : 0) + outgoingAvatarOverlap) : 0
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
}

//MARK: - UIImagePickerControllerDelegate methods
extension ChatRoomViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let resizeImage = pickerImage.resizeImage(targetSize: CGSize(width: 1242, height: 1242))
                self.sendImage(img: resizeImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - SBDChannelDelegate methods
extension ChatRoomViewController: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        
        if let msg = message as? SBDUserMessage {
            // Do something when the received message is a UserMessage.
            
            let sender = Sender(id: msg.sender?.userId ?? "", displayName: msg.sender?.nickname ?? "", avatarUrl: msg.sender?.profileUrl ?? "")
            
            
            let message = MockMessage(text: msg.message ?? "", sender: sender, messageId: msg.requestId ?? "", date: Date())
            self.insertMessage(message)
            
        }
        else if let msgFile = message as? SBDFileMessage {
            // Do something when the received message is a FileMessage.
            let sender = Sender(id: msgFile.sender?.userId ?? "", displayName: msgFile.sender?.nickname ?? "", avatarUrl: msgFile.sender?.profileUrl ?? "")
            
            
            let message = MockMessage(urlImage: URL(string: msgFile.url)!, sender: sender, messageId: "", date: Date())
            
            self.insertMessage(message)
            
        }
        else if message is SBDAdminMessage {
            // Do something when the received message is an AdminMessage.
        }
        
        channel?.markAsRead()
        self.chatTableReload(initial: true)
    }
}

// MARK: - MessageInputBarDelegate
extension ChatRoomViewController: MessageInputBarDelegate {
    
    //MARK: Send Text Message
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        if isShowTempData {
            // Here we can parse for which substrings were autocompleted
            let attributedText = messageInputBar.inputTextView.attributedText!
            let range = NSRange(location: 0, length: attributedText.length)
            
            let components = inputBar.inputTextView.components
            messageInputBar.inputTextView.text = String()
            messageInputBar.invalidatePlugins()
            
            // Send button activity animation
            DispatchQueue.global(qos: .default).async {
                // fake send request task
                sleep(1)
                DispatchQueue.main.async { [weak self] in
                    self?.messageInputBar.inputTextView.placeholder = "Aa"
                    self?.insertMessages(components)
                    self?.messagesCollectionView.scrollToBottom(animated: true)
                }
            }
        }
        
        /*
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                if self.channel == nil {
                    createNewChatGroup { (channel) in
                        if let chnl = channel {
                            self.channel = chnl
                            self.sendMessage(text: str)
                        }
                    }
                } else {
                    sendMessage(text: str)
                }
            } else if let img = component as? UIImage {
                sendImage(img: img)
            }
        }
        
        inputBar.inputTextView.text = String()
        inputBar.sendButton.isEnabled = true
        */
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = SampleData.shared.currentSender
            if let str = component as? String {
                let message = MockMessage(text: str, sender: user, messageId: UUID().uuidString, date: Date())
                insertMessages(message)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, sender: user, messageId: UUID().uuidString, date: Date())
                insertMessages(message)
            }
        }
    }
    
    
    func sendMessage(text: String) {
        ChatManager().sendTextMessage(text, channel: channel, completionHandler: { (message) in
            let profile = Authorization.shared.profile
            let senderId = profile?.userId ?? ""
            let senderName = profile?.name ?? ""
            let senderImageUrl = profile?.photo?.thumb ?? ""
            let sender = Sender(id: senderId, displayName: senderName, avatarUrl: senderImageUrl)
            let message = MockMessage(text: text, sender: sender, messageId: "\(message?.messageId ?? 0)", date: Date())
            self.insertMessage(message)
            self.chatTableReload(initial: true)
        }) { (error) in
            
        }
    }
    
    func sendImage(img:UIImage) {
        let stringname = Utils.getFileName("jpg")
        let imageFolder = "\(stringname)"
        if Utils.saveImageInApp(imageFolder, img) {
            ChatManager().sendImageFileMessage(self.channel, stringname, completionHandler: { (fileMessage) in
                self.channel?.markAsRead()
            }, errorHandler: { (error) in
                
            })
            
            //dont wait to upload image to server
            let sender = Sender(id: Authorization.shared.profile?.userId ?? "", displayName: Authorization.shared.profile?.name ?? "", avatarUrl: Authorization.shared.profile?.photo?.thumb ?? "")
            let message = MockMessage(image: img, sender: sender, messageId: "", date: Date())
            
            self.messageList.append(message)
            self.chatTableReload(initial: true)
        }
    }
}


