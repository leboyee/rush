//
//  ClubNameCell.swift
//  Rush
//
//  Created by ideveloper on 29/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ClubNameCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Other functions
extension ClubNameCell {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detail: String, numberOfLines: Int) {
        detailLabel.text = detail
        detailLabel.numberOfLines = numberOfLines
    }
}
