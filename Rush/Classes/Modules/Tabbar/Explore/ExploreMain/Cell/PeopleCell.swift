//
//  SearchClubCell.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var topSeparator: UILabel!
    @IBOutlet weak var selectionButton: UIButton!

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
extension PeopleCell {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setupImage(image: UIImage) {
        profileImage.image = image
    }
    
    func setup(checkMark: Bool) {
        self.accessoryType = checkMark == true ? .checkmark : .none
    }
    
    func setup(isHidden: Bool) {
        self.selectionButton.isHidden = isHidden
    }
    
    func setup(isSelected: Bool) {
        self.selectionButton.isSelected = isSelected
    }
    
    func setup(isHideTopSeparator: Bool) {
        topSeparator.isHidden = isHideTopSeparator
    }
    
}
