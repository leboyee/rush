//
//  InstagramCell.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class InstagramCell: UITableViewCell {

    var instagramEvent: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Actions
extension InstagramCell {
    
    @IBAction func connectButtonAction() {
        instagramEvent?()
    }
    
}

// MARK: - Data functions
extension InstagramCell {

    func set(instagramStatus: Bool) {
        
    }
    
    
}
