//
//  PostCommentCell.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostCommentCell: UITableViewCell {
    
    @IBOutlet weak var leadingConstrainttOfImageView: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var userProfileClickEvent:(() -> Void)?
    var userNameClickEvent: ((_ name: String) -> Void)?
    var replyClickEvent: (() -> Void)?
    var username = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        self.detailLabel.addGestureRecognizer(tap)
        self.detailLabel.isUserInteractionEnabled = true
        
        imgView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - Other functions
extension PostCommentCell {
    func setup(isReplayCell: Bool) {
        if isReplayCell {
            widthConstraintOfImageView.constant = 24
            heightConstraintOfImageView.constant = 24
            leadingConstrainttOfImageView.constant = 72
            imgView.layer.cornerRadius = 12
        } else {
            widthConstraintOfImageView.constant = 40
            heightConstraintOfImageView.constant = 40
            leadingConstrainttOfImageView.constant = 24
            imgView.layer.cornerRadius = 20
        }
    }
    
    func setup(name: String, attributedText: String) {
        username = name
        let text = Utils.setAttributedText(name, ", Yes, me too!", 17, 17)
        detailLabel.attributedText = text
    }
    
    func setup(username: String) {
        usernameLabel.text = username
    }
    
    func setup(image: URL?) {
        if image != nil {
            imgView.contentMode = .scaleAspectFill
            imgView.layer.borderWidth = 0
            imgView.sd_setImage(with: image, placeholderImage: #imageLiteral(resourceName: "placeHolderIcon"), options: [], context: nil)
        } else {
            imgView.image = #imageLiteral(resourceName: "placeHolderIcon")
            imgView.contentMode = .scaleToFill
            imgView.layer.borderWidth = 1
        }
    }
    
    func setup(commentText: String) {
        detailLabel.text = commentText
    }
    
    func setup(date: String) {
        dateLabel.text = date
    }
    
    @IBAction func replayButtonAction() {
        replyClickEvent?()
    }
    
    @IBAction func userProfileButtonAction() {
        userProfileClickEvent?()
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        
        let range = detailLabel.text?.range(of: "Peter Rally")
        if range != nil {
            let nsrange = detailLabel.text?.nsRange(from: range!)
            if gesture.didTapAttributedTextInLabel(label: detailLabel, targetRange: nsrange!) {
                userNameClickEvent?(username)
            }
        }
    }
}
