//
//  EventCell.swift
//  Rush
//
//  Created by ideveloper on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {

    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var privacyImageView: UIImageView!
    @IBOutlet weak var widthConstraintOfDateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateNumericLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classCountLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
