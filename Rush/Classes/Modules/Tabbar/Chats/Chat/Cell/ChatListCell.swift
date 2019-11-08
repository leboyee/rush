//
//  ChatListCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import SendBirdSDK

class ChatListCell: MGSwipeTableCell {

    @IBOutlet weak var topConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintOfDateLabel: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var onlineView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Other functions
extension ChatListCell {
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detail: String) {
        detailLabel.text = detail
    }
    
    func setup(bottomConstraintOfImage: CGFloat) {
        bottomConstraintOfImageView.constant = bottomConstraintOfImage
    }
    
    func setup(bottomConstraintOfDate: CGFloat) {
        bottomContraintOfDateLabel.constant = bottomConstraintOfDate
    }
    
    func setup(cornerRadius: CGFloat) {
        imgView.layer.cornerRadius = cornerRadius
    }
    
    func setup(isHideSeparator: Bool) {
        separatorView.isHidden = isHideSeparator
    }
    
    func setup(isOnline: Bool) {
        onlineView.isHidden = !isOnline
    }
}

extension ChatListCell {
    
    func setup(lastMessage: SBDBaseMessage?) {
        var messageText = ""
        
        if lastMessage != nil {
            // text message
            if let message = lastMessage as? SBDUserMessage {
                messageText = message.message ?? messageText
            } else if (lastMessage as? SBDFileMessage) != nil {
                messageText = "Image"
            } else if let message = lastMessage as? SBDAdminMessage {
                messageText = message.message ?? messageText
            }
        }
        detailLabel.text = messageText
    }
    
    func setup(onlineUser: NSMutableArray?) {
        onlineView.isHidden = true
        if let members = onlineUser {
            var isOnline = false
            for member in members {
                if let user = member as? SBDUser {
                    let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                    if loggedInUserId != user.userId {
                        if user.connectionStatus == .online {
                            isOnline = true
                        }
                    }
                }
            }
            onlineView.isHidden = !(isOnline)
        }
    }
    
    func setup(chatImage: NSMutableArray?) {
        if let members = chatImage {
            for member in members {
                if let user = member as? SBDUser {
                    let loggedInUserId = Authorization.shared.profile?.userId ?? ""
                    if loggedInUserId != user.userId {
                        imgView.sd_setImage(with: URL(string: user.profileUrl ?? ""), placeholderImage: #imageLiteral(resourceName: "img-event"), options: [], context: nil)
                    }
                }
            }
        }
    }
    
    func setup(img: String?) {
        if let value = img {
            imgView.contentMode = .scaleAspectFill
            imgView.backgroundColor = .clear
            imgView.sd_setImage(with: URL(string: value), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-48px"))
        }
    }
    
    func setup(channel: SBDGroupChannel) {
        // Set last time
        if let message = channel.lastMessage {
            let date = Date(timeIntervalSince1970: TimeInterval(exactly: message.createdAt/1000)!)
            timeLabel.text = " ⋅ " + date.timeAgoDisplay()
        } else {
            let date = Date(timeIntervalSince1970: TimeInterval(exactly: channel.createdAt)!)
            timeLabel.text = date.timeAgoDisplay()
        }
        
        if Int(channel.unreadMessageCount) > 0 {
            onlineView.isHidden = false
        } else {
            onlineView.isHidden = true
        }
    }
}
