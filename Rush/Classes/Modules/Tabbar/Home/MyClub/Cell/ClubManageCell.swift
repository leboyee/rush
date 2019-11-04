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
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var secondButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintOfSecondButton: NSLayoutConstraint!
    
    var firstButtonClickEvent: (() -> Void)?
    var secondButtonClickEvent: (() -> Void)?
    var messageButtonClickEvent: (() -> Void)?
    @IBOutlet weak var topConstraintOfButton: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfMessageButton: NSLayoutConstraint!
    let topPadding: CGFloat = 16.0
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
            secondButton.setTitle(Text.message, for: .normal)
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
    
     func setup(onlyFirstButtonType: ManageButtonType) {
         firstButton.isHidden = true
         secondButton.isHidden = true
         messageView.isHidden = false
        topConstraintOfMessageButton.constant = topPadding
         if onlyFirstButtonType == .manage {
             messageButton.setImage(#imageLiteral(resourceName: "club-manage"), for: .normal)
             messageButton.setTitle(Text.manage, for: .normal)
             messageButton.setTitleColor(UIColor.bgBlack, for: .normal)
             messageButton.backgroundColor = UIColor.lightGray93
         } else if onlyFirstButtonType == .friends {
             messageButton.setImage(#imageLiteral(resourceName: "friend-checkmark"), for: .normal)
             messageButton.setTitle(Text.friends, for: .normal)
             messageButton.setTitleColor(UIColor.bgBlack, for: .normal)
             messageButton.backgroundColor = UIColor.lightGray93
         } else if onlyFirstButtonType == .addFriend {
             messageButton.setImage(#imageLiteral(resourceName: "friend-profile"), for: .normal)
             messageButton.setTitle(Text.friend, for: .normal)
             messageButton.setTitleColor(UIColor.white, for: .normal)
             messageButton.backgroundColor = UIColor.bgBlack
         } else if onlyFirstButtonType == .requested {
             messageButton.setImage(#imageLiteral(resourceName: "friend-requested"), for: .normal)
             messageButton.setTitle(Text.requested, for: .normal)
             messageButton.setTitleColor(UIColor.bgBlack, for: .normal)
             messageButton.backgroundColor = UIColor.lightGray93
         } else if onlyFirstButtonType == .joined || onlyFirstButtonType == .going {
             let text = onlyFirstButtonType == .joined ? Text.joined : Text.going
             messageButton.setImage(#imageLiteral(resourceName: "friend-checkmark"), for: .normal)
             messageButton.setTitle(text, for: .normal)
             messageButton.setTitleColor(UIColor.bgBlack, for: .normal)
             messageButton.backgroundColor = UIColor.lightGray93
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
    
    @IBAction func messageButtonAction() {
        messageButtonClickEvent?()
    }
}
