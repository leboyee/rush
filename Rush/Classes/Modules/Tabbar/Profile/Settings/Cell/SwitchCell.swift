//
//  SwitchCell.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var swt: RSwitch!

    var switchEvent: ((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Actions
extension SwitchCell {
    
    @IBAction func switchValueChanged() {
        switchEvent?(swt.isOn)
    }
    
}

// MARK: - Data Functions
extension SwitchCell {
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(isOn: Bool) {
        swt.isOn = isOn
    }
}
