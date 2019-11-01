//
//  CreateUserPostCell.swift
//  Rush
//
//  Created by ideveloper on 29/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CreateUserPostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CreateUserPostCell {
    func setup(font: UIFont) {
        titleLabel.font = font
    }
    
    func setup(url: URL?) {
        imgView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder-profile-32px"))
    }
    
    func setup(containViewColor: UIColor) {
        containView.backgroundColor = containViewColor
    }
    
    func setup(titleColor: UIColor) {
        titleLabel.textColor = titleColor
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
}
