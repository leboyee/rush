//
//  CalendarDayCell.swift
//  digicrony_ios
//
//  Created by kamal on 23/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

class CalendarDayCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var dotView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        dotView.backgroundColor = UIColor.brown24
        dateLabel.textColor = UIColor.white
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
    
    func setup(isSelected: Bool) {
        outerView.backgroundColor = isSelected ? UIColor.brown24 : UIColor.clear
        outerView.layer.cornerRadius = outerView.frame.height/2.0
        //dateLabel.textColor = isSelected ? UIColor.white : UIColor.white
    }
}
