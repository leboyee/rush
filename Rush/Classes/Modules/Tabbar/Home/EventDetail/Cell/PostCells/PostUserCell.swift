//
//  PostUserCell.swift
//  Rush
//
//  Created by kamal on 11/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostUserCell: UITableViewCell {

    @IBOutlet weak var nameLabel: CustomBlackLabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

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
extension PostUserCell {    
    @IBAction func moreButtonAction() {
        Utils.notReadyAlert()
    }
}

// MARK: - Others
extension PostUserCell {

    func set(name: String) {
        nameLabel.text = name
    }
    
    func set(time: Date?) {
        timeLabel.text = time?.toString(format: "MMM dd") ?? "Now"
    }
    
    func set(url: URL?) {
        profileImageView.sd_setImage(with: url, placeholderImage: nil)
    }
}
