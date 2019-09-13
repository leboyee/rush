//
//  ClubManageCell.swift
//  Rush
//
//  Created by ideveloper on 29/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum ManageButtonType {
    case none
    case addFriend
    case requested
    case friends
    case message
    case accept
    case reject
    case manage
    case groupChat
    case joined
    case groupChatClub
    case going

}

class ClubManageCell: UITableViewCell {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    var firstButtonClickEvent: (() -> Void)?
    var secondButtonClickEvent: (() -> Void)?
    @IBOutlet weak var topConstraintOfButton: NSLayoutConstraint!
    
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
extension ClubManageCell {
    
    func setup(firstButtonType: ManageButtonType) {
        messageView.isHidden = true
        if firstButtonType == .manage {
            firstButton.setImage(#imageLiteral(resourceName: "club-manage"), for: .normal)
            firstButton.setTitle(Text.manage, for: .normal)
            firstButton.setTitleColor(UIColor.bgBlack, for: .normal)
            firstButton.backgroundColor = UIColor.lightGray93
        } else if firstButtonType == .friends {
            firstButton.setImage(#imageLiteral(resourceName: "friend-checkmark"), for: .normal)
            firstButton.setTitle(Text.friends, for: .normal)
            firstButton.setTitleColor(UIColor.bgBlack, for: .normal)
            firstButton.backgroundColor = UIColor.lightGray93
        } else if firstButtonType == .addFriend {
            firstButton.setImage(#imageLiteral(resourceName: "friend-profile"), for: .normal)
            firstButton.setTitle(Text.friend, for: .normal)
            firstButton.setTitleColor(UIColor.white, for: .normal)
            firstButton.backgroundColor = UIColor.bgBlack
        } else if firstButtonType == .accept {
            firstButton.setImage(nil, for: .normal)
            firstButton.setTitle(Text.accept, for: .normal)
            firstButton.setTitleColor(UIColor.white, for: .normal)
            firstButton.backgroundColor = UIColor.green24
        } else if firstButtonType == .requested {
            firstButton.setImage(#imageLiteral(resourceName: "friend-requested"), for: .normal)
            firstButton.setTitle(Text.requested, for: .normal)
            firstButton.setTitleColor(UIColor.bgBlack, for: .normal)
            firstButton.backgroundColor = UIColor.lightGray93
        } else if firstButtonType == .joined || firstButtonType == .going {
            let text = firstButtonType == .joined ? Text.joined : Text.going
            firstButton.setImage(#imageLiteral(resourceName: "friend-checkmark"), for: .normal)
            firstButton.setTitle(text, for: .normal)
            firstButton.setTitleColor(UIColor.bgBlack, for: .normal)
            firstButton.backgroundColor = UIColor.lightGray93
        }
    }
    
    func setup(secondButtonType: ManageButtonType) {
        messageView.isHidden = true
        if secondButtonType == .groupChat {
            secondButton.setImage(#imageLiteral(resourceName: "club-grpchat"), for: .normal)
            secondButton.setTitle(Text.groupChat, for: .normal)
            secondButton.setTitleColor(UIColor.white, for: .normal)
            secondButton.backgroundColor = UIColor.bgBlack
        } else if secondButtonType == .message {
            secondButton.setImage(#imageLiteral(resourceName: "message-profile"), for: .normal)
            secondButton.setTitle(Text.messages, for: .normal)
            secondButton.setTitleColor(UIColor.bgBlack, for: .normal)
            secondButton.backgroundColor = UIColor.lightGray93
        } else if secondButtonType == .reject {
            secondButton.setImage(nil, for: .normal)
            secondButton.setTitle(Text.reject, for: .normal)
            secondButton.setTitleColor(UIColor.white, for: .normal)
            secondButton.backgroundColor = UIColor.brown24
        } else if secondButtonType == .groupChatClub {
            secondButton.setImage(#imageLiteral(resourceName: "club-grpchat"), for: .normal)
            secondButton.setTitle(Text.groupChat, for: .normal)
            secondButton.setTitleColor(UIColor.bgBlack, for: .normal)
            secondButton.backgroundColor = UIColor.lightGray93
        }
    }
    
    func setup(isOnlyShowMessage: Bool) {
        if isOnlyShowMessage {
            messageView.isHidden = false
        } else {
            messageView.isHidden = true
        }
    }
    
    func setup(topConstraint: CGFloat) {
        topConstraintOfButton.constant = topConstraint
    }
}

// MARK: - Actions
extension ClubManageCell {
    
    @IBAction func firstButtonAction() {
        firstButtonClickEvent?()
    }
    
    @IBAction func secondButtonAction() {
        secondButtonClickEvent?()
    }
}
