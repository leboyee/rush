//
//  InstagramCell.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class InstagramCell: UITableViewCell {

    @IBOutlet weak var connectLabel: UILabel!
    
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

// MARK: - Actions
extension InstagramCell {
    
    @IBAction func connectButtonAction() {
        instagramEvent?()
    }
    
}

// MARK: - Data functions
extension InstagramCell {

    func set(instagramStatus: Bool, user: String?) {
        if instagramStatus {
            var text = ""
            if let name = user, name.isNotEmpty {
                text = "Connected\n\(name)"
            } else {
                text = "Connected"
            }
            
            let attr = NSMutableAttributedString(
                string: text,
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.green24,
                    NSAttributedString.Key.font: UIFont.semibold(sz: 13.0)
                ])
            
            if let name = user, name.isNotEmpty {
                let range = (text as NSString).range(of: name)
                attr.addAttributes([
                    NSAttributedString.Key.foregroundColor: UIColor.gray47,
                    NSAttributedString.Key.font: UIFont.regular(sz: 13.0)
                    ], range: range)
            }
            connectLabel.attributedText = attr
        } else {
            connectLabel.text = "Connect"
            connectLabel.textColor = UIColor.darkPink
        }
    }
}
