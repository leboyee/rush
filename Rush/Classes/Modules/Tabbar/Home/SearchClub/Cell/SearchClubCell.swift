//
//  SearchClubCell.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class SearchClubCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var topSeparator: UILabel!
    
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
extension SearchClubCell {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(checkMark: Bool) {
        self.accessoryType = checkMark == true ? .checkmark : .none
    }
    
    func setup(isHideTopSeparator: Bool) {
        topSeparator.isHidden = isHideTopSeparator
    }
    
}
