//
//  PostTextCell.swift
//  Rush
//
//  Created by kamal on 11/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostLikeCell: UITableViewCell {
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var upvoteCountLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var downvoteCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var upvoteClickEvent: (() -> Void)?
    var downvoteClickEvent: (() -> Void)?
    var commentClickEvent: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension PostTextCell {
    func set(text: String) {
        label.text = text
    }
}

// MARK: - Others
extension PostLikeCell {
    func setup(upvote: String) {
        upvoteCountLabel.text = upvote.isEmpty ? "0" : upvote
    }
    
    func setup(downvote: String) {
        downvoteCountLabel.text = downvote.isEmpty ? "0" : downvote
    }
    
    func setup(comment: String) {
        commentCountLabel.text = comment.isEmpty ? "0" : comment
    }
    
    @IBAction func commentButtonAction() {
        
    }
    
    @IBAction func upvoteButtonAction() {
        
    }
    
    @IBAction func downvoteButtonAction() {
        
    }
}
