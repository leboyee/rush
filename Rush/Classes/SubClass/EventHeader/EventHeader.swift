//
//  EventHeader.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol EventHeaderDelegate: class {
    func didTappedCalendar()
}

class EventHeader: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: CustomBlackLabel!
    @IBOutlet weak var dayLabel: CustomBlackLabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateView: RBackgoundView!
    @IBOutlet weak var headerImage: UIImageView!

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
        let nib  = UINib(nibName: String(describing: EventHeader.self), bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.clipsToBounds = true
            addSubview(view)
            addViewConstraint(view: view)
            dateView.roundAllCorners(with: 24.0)
        }
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
    
    func set(date: Date?) {
        guard let date = date else {
            dateView.isHidden = true
            return
        }
        
        dateView.isHidden = false
        monthLabel.text = date.toString(format: "MMM").uppercased()
        dateLabel.text = date.toString(format: "dd")
        dayLabel.text = date.toString(format: "EEEE")

    }

    func set(start: Date?, end: Date?) {

        guard let startDate = start else {
            timeLabel.text = ""
            return
        }

        var text = startDate.toString(format: "hh:mma")
        if let endDate = end {
            text +=  "-" +  endDate.toString(format: "hh:mma")
        }
        timeLabel.text = text
    }
    
    func set(url: URL?) {
        headerImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder-eventMain-1242.pdf"))
    }
}

// MARK: - Actions
extension EventHeader {
    
    @IBAction func calendarButtonAction() {
        delegate?.didTappedCalendar()
    }
}
