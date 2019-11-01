//
//  UserNameTableViewCell.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postUserDescripation: UILabel!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
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
extension UserNameTableViewCell {
    func setup(title: String) {
        postUserName.text = title
    }
    
    func setup(detail: String) {
        postUserDescripation.text = detail
    }
    
    func setup(url: URL?) {
        postImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder-profile-48px"))
    }
}
