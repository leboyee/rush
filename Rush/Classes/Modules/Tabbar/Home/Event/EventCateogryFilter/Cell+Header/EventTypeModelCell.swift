//
//  EventCategoryFilterCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventTypeModelCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var eventDetailLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        eventDetailLabel.numberOfLines = 0
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension EventTypeModelCell {
    
    func setup(name: String) {
        nameLabel.text = name
    }
    
    func setup(checkMarkHidden: Bool) {
        checkMarkImageView.isHidden = checkMarkHidden
    }
    
    func setup(detail: String) {
        eventDetailLabel.text = detail
    }
    
    func setup(isSelected: Bool) {
        cellBackgroundView.backgroundColor = isSelected == true ? .lightGray93 : .white
    }
    
}
