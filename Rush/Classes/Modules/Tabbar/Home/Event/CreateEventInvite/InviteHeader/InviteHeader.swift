//
//  InviteHeader.swift
//  GotFriends
//
//  Created by iChirag on 09/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit

class InviteHeader: UITableViewHeaderFooterView {
   
    @IBOutlet weak var headerTextLabel: CustomLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization cod
    }

    func setup(headerText: String) {
        self.headerTextLabel.text = headerText
    }
}
