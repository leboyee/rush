//
//  CheckMarkCell.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CheckMarkCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tickImageView.image = isDarkModeOn ? #imageLiteral(resourceName: "checkmark-red.pdf") : #imageLiteral(resourceName: "checkmark-red.pdf")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Other functions
extension CheckMarkCell {
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(isCheckMarkShow: Bool) {
        tickImageView.isHidden = !isCheckMarkShow
    }
    
    func set(isCheckBoxShow: Bool) {
        tickImageView.image = isCheckBoxShow ? #imageLiteral(resourceName: "selected.pdf") : #imageLiteral(resourceName: "empty.pdf")
    }
    
}
