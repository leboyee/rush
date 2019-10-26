//
//  ChatUserCell.swift
//  Rush
//
//  Created by ideveloper on 05/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ChatUserCell: UICollectionViewCell {
    
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onlineView.backgroundColor = isDarkModeOn ? UIColor.bgBlack17 : UIColor.bgWhite96
    }
}

// MARK: - Others
extension ChatUserCell {
    func setup(isHideArrowView: Bool) {
        arrowView.isHidden = isHideArrowView
        onlineView.isHidden = !isHideArrowView
    }
    
    func setup(img: String?) {
        imgView.sd_setImage(with: URL(string: img ?? ""), placeholderImage: #imageLiteral(resourceName: "mask"))
    }
    
    func setup(isHideOnlineView: Bool) {
        onlineView.isHidden = !isHideOnlineView
    }
}
