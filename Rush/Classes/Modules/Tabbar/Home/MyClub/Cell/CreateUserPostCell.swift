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
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 16
        iconImageView.clipsToBounds = true
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
    
    func setup(containViewColor: UIColor) {
        containView.backgroundColor = containViewColor
    }
    
    func setup(titleColor: UIColor) {
        titleLabel.textColor = titleColor
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func set(url: URL?) {
        iconImageView.sd_setImage(with: url, placeholderImage: nil)
    }


}
