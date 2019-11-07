//
//  NoEventsCell.swift
//  Rush
//
//  Created by ideveloper on 05/11/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class NoEventsCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Others
extension NoEventsCell {
    func setClub() {
        imgView.image = #imageLiteral(resourceName: "placeholder-noClubs")
        txtLabel.text = "There are no clubs"
    }
    
    func setClasses() {
        imgView.image = #imageLiteral(resourceName: "placeholder-noClasses")
        txtLabel.text = "There are no classes"
    }
    
    func setEvents() {
        imgView.image = #imageLiteral(resourceName: "placeholder-noEvents")
        txtLabel.text = "There are no events"
    }
    
    func setUpcomingEvents() {
        imgView.image = #imageLiteral(resourceName: "placeholder-noEvents")
        txtLabel.text = "There are no upcoming events"
    }
    
    func set(title: String) {
        txtLabel.text = title
    }
}
