//
//  EventByDateCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ExploreCell: UITableViewCell {
    
    @IBOutlet weak var widthConstraintOfDateView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
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
extension ExploreCell {
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detail: String) {
        detailLabel.text = detail
    }
    
    func setup(isHideSeparator: Bool) {
        separatorView.isHidden = isHideSeparator
    }
    func setup(img1Url: String, img2Url: String, img3Url: String, type: String) {
        var image: UIImage?
        if type == "Event" {
            image = UIImage(named: "placeholder-event48px")
        } else if type == "Club" {
            image = UIImage(named: "placeholder-club48px")
        } else if type == "Class" {
            image = UIImage(named: "placeholder-classes48px")
        }
        imgView?.sd_setImage(with: img1Url.photo?.url(), placeholderImage: image)
        imgView2?.sd_setImage(with: img2Url.photo?.url(), placeholderImage: image)
        imgView3?.sd_setImage(with: img3Url.photo?.url(), placeholderImage: image)
    }
}
