//
//  PostLikeCell.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostLikeCell: UITableViewCell {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var unlikeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var likeButtonEvent: (() -> Void)?
    var unlikeButtonEvent: (() -> Void)?
    var commentButtonEvent: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - Actions
extension PostLikeCell {
    
    @IBAction func likeButtonAction() {
        likeButtonEvent?()
    }
    
    @IBAction func unlikeButtonAction() {
        unlikeButtonEvent?()
    }
    
    @IBAction func commentButtonAction() {
        commentButtonEvent?()
    }
}

// MARK: - Others
extension PostLikeCell {
    func set(numberOfLike: Int) {
        likeLabel.text = "\(numberOfLike)"
    }
    
    func set(numberOfUnLike: Int) {
        unlikeLabel.text = "\(numberOfUnLike)"
    }
    
    func set(numberOfComment: Int) {
        commentLabel.text = "\(numberOfComment)"
    }
    
    func set(ishideUnlikeLabel: Bool) {
        unlikeLabel.isHidden = ishideUnlikeLabel
    }
    
    func set(vote: Int) {
        if vote == 1 {
            upButton.isSelected = true
            downButton.isSelected = false
        } else if vote == -1 {
            upButton.isSelected = false
            downButton.isSelected = true
        } else {
            upButton.isSelected = false
            downButton.isSelected = false
        }
    }
}
