//
//  SingleButtonCell.swift
//  Rush
//
//  Created by ideveloper on 01/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class SingleButtonCell: UITableViewCell {
    
    @IBOutlet weak var joinButton: UIButton!
    var joinButtonClickEvent: (() -> Void)?

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
extension SingleButtonCell {
    @IBAction func joinButtonAction() {
        joinButtonClickEvent?()
    }
}
