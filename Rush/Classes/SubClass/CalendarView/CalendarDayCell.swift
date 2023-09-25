//
//  CalendarDayCell.swift
//  digicrony_ios
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//
import UIKit

class CalendarDayCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var dotView: UIView!
    var outerViewSelectedColor: UIColor = UIColor.brown24
    var dateSelectedColor: UIColor = .white
    var dateColor: UIColor = .white
    override func awakeFromNib() {
        super.awakeFromNib()
        dotView.backgroundColor = UIColor.brown24
        dateLabel.textColor = dateColor
    }
    
}

// MARK: - Data
extension CalendarDayCell {
    
    func setup(date: Date) {
        dateLabel.text = date.toString(format: "dd")
    }
    
    func setup(isEventExist: Bool) {
        dotView.isHidden = !isEventExist
    }
    
    func setup(dateColor: UIColor) {
        dateLabel.textColor = dateColor
        self.dateColor = dateColor
    }
    
    func setup(dotColor: UIColor) {
        dotView.backgroundColor = dotColor
    }
    
    func setup(outerViewBgSelectedColor: UIColor) {
        outerViewSelectedColor = outerViewBgSelectedColor
    }
    
    func setup(dateSelectedColor: UIColor) {
        dateLabel.textColor = dateSelectedColor
        self.dateSelectedColor = dateSelectedColor
    }
    
    func setup(isSelected: Bool) {
        outerView.backgroundColor = isSelected ? outerViewSelectedColor : UIColor.clear
        outerView.layer.cornerRadius = outerView.frame.height/2.0
        dateLabel.textColor = isSelected ? dateSelectedColor : dateColor
    }
}
