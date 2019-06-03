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
}

class ClubManageCell: UITableViewCell {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    var firstButtonClickEvent: (() -> Void)?
    var secondButtonClickEvent: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Other functions
extension ClubManageCell {
    
    func setup(firstButtonType: ManageButtonType) {
        
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
        }
    }
    
    func setup(secondButtonType: ManageButtonType) {
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
        }
    }
}

//MARK: - Actions
extension ClubManageCell {
    
    @IBAction func firstButtonAction() {
        firstButtonClickEvent?()
    }
    
    @IBAction func secondButtonAction() {
        secondButtonClickEvent?()
    }
}
