//
//  PostBottomCell.swift
//  Rush
//
//  Created by Kamal Mittal on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostBottomCell: UITableViewCell {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
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
extension PostBottomCell {
    
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
extension PostBottomCell {
    func set(numberOfLike: Int) {
        likeLabel.text = "\(numberOfLike)"
    }
    
    func set(numberOfComment: Int) {
        commentLabel.text = "\(numberOfComment)"
    }
}
