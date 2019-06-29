//
//  ClassesCell.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ClassesCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var selectedButton: UIButton!

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
extension ClassesCell {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(isSelected: Bool) {
        self.selectedButton.isSelected = isSelected
    }
    
}
