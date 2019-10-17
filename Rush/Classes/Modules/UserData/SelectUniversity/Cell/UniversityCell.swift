//
//  UniversityCell.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UniversityCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var universityImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        universityImageView.clipsToBounds = true
        universityImageView.layer.cornerRadius = 16
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Other functions
extension UniversityCell {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(checkMark: Bool) {
        self.tickImageView.isHidden = !checkMark
    }
    
    func setup(url: URL) {
        universityImageView.sd_setImage(with: url, completed: nil)
    }
    
}
