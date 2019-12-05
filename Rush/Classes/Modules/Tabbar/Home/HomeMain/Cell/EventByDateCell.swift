//
//  EventByDateCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventByDateCell: UITableViewCell {

    @IBOutlet weak var leadingConstraintOfDateView: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintOfDateView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintOfDateLabel: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintOfDot: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: CustomBlackLabel!
    @IBOutlet weak var threeDots: UIButton!
 //   var cellSelected: ((_ type: EventCategoryType, _ id: Int, _ index: Int) -> Void)?
    var shareClickEvent: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        trailingConstraintOfDot.constant = -24
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shareAction(_ sender: Any) {
        shareClickEvent?()
    }
}

// MARK: - Other functions
extension EventByDateCell {
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detail: String) {
        detailLabel.text = detail
    }
    
    // use this for event
    func setup(eventImageUrl: URL?) {
        if eventImageUrl != nil {
            imgView.sd_setImage(with: eventImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-event48px"))
        } else {
            imgView.image = #imageLiteral(resourceName: "placeholder-event48px")
        }
    }
    
    // use this for club
    func setup(clubImageUrl: URL?) {
        if clubImageUrl != nil {
            imgView.sd_setImage(with: clubImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-club48px"))
        } else {
            imgView.image = #imageLiteral(resourceName: "placeholder-club48px")
        }
    }
    
    // use this for classes
    func setup(classesImageUrl: URL?) {
        if classesImageUrl != nil {
            imgView.sd_setImage(with: classesImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-classChat-#1"))
        } else {
            imgView.image = #imageLiteral(resourceName: "placeholder-classChat-#1")
        }
    }
    
    func setup(date: Date?) {
        guard let date = date else {
            dateLabel.isHidden = true
            return
        }
        
        dateLabel.isHidden = false
        monthLabel.text = date.toString(format: "MMM").uppercased()
        dateLabel.text = date.toString(format: "dd")
//        dayLabel.text = date.toString(format: "EEEE")
        
    }
    
    func setup(start: Date?, end: Date?) {
        
        guard let startDate = start else {
            detailLabel.text = ""
            return
        }
        
        var text = startDate.toString(format: "hh:mma")
        if let endDate = end {
            text +=  "-" +  endDate.toString(format: "hh:mma")
        }
        detailLabel.text = text
    }
    
    func setup(isRemoveDateView: Bool) {
        if isRemoveDateView {
            leadingConstraintOfDateView.constant = 8
            widthConstraintOfDateView.constant = 0
            topConstraintOfImageView.constant = 0
        } else {
            leadingConstraintOfDateView.constant = 16
            widthConstraintOfDateView.constant = 48
            topConstraintOfImageView.constant = 20
        }
    }
    
    func setup(bottomConstraintOfImage: CGFloat) {
        bottomConstraintOfImageView.constant = bottomConstraintOfImage
    }
    
    func setup(bottomConstraintOfDate: CGFloat) {
        bottomContraintOfDateLabel.constant = bottomConstraintOfDate
    }
    
    func setup(cornerRadius: CGFloat) {
        imgView.layer.cornerRadius = cornerRadius
    }
    
    func setup(isHideSeparator: Bool) {
        separatorView.isHidden = isHideSeparator
    }
    
    func setup(dotButtonConstraint: CGFloat) {
        trailingConstraintOfDot.constant = dotButtonConstraint
    }
}
