//
//  EventHeader.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol EventHeaderDelegate: class {

}

class EventHeader: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    weak var delegate: EventHeaderDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}

extension EventHeader {
    
    private func commonInit() {
        let nib  = UINib(nibName: String(describing: ParallaxHeader.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.clipsToBounds = true
        addSubview(view)
        addViewConstraint(view: view)
        
    }
    
    private func addViewConstraint(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = view.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        addConstraints([top, bottom, trailing, leading])
    }
    
}

// MARK: - Other
extension EventHeader {
    
    func set(date: Date) {

    }

    func set(start: Date, end: Date) {

    }
}

//MARK:- Actions
extension EventHeader {
    
    @IBAction func calendarButtonAction() {
        Utils.notReadyAlert()
    }
}
