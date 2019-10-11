//
//  NotificationCell.swift
//  Rush
//
//  Created by kamal on 14/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var eventImageView: UIImageView!

    let startSeparator = "⌠"
    let endSeparator = "⌡"
    var ranges = [NSRange]()
    
    var labelTapEvent:((_ text: String, _ range: NSRange) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventImageView.layer.borderWidth = 3.0
        eventImageView.layer.borderColor = UIColor.gray96.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NotificationCell {
    
    func setup() {
        let detailText = "⌠Marta Keller⌡ invites you to join ⌠VR Meetips⌡"
        label.attributedText = getFormattedString(string: detailText)
    }
    
    func set(friend: Friend?, text: String) {
        let friendNameText = "{friend_user_name}"
        let name = startSeparator + (friend?.user?.name ?? "") + endSeparator
        let detailText = text.replacingOccurrences(of: friendNameText, with: name)
        label.attributedText = getFormattedString(string: detailText)
        userImageView.sd_setImage(with: friend?.user?.photo?.urlThumb(), placeholderImage: nil)
        eventImageView.sd_setImage(with: Authorization.shared.profile?.photo?.urlThumb(), placeholderImage: nil)
    }
    
    func set(user: User?, event: Event?, text: String) {
        let userName = "{user_name}"
        let eventName = "{event_name}"
        let name = startSeparator + (user?.name ?? "") + endSeparator
        let event = startSeparator + (event?.title ?? "") + endSeparator

        var detailText = text.replacingOccurrences(of: userName, with: name)
        detailText = detailText.replacingOccurrences(of: eventName, with: event)
        
        label.attributedText = getFormattedString(string: detailText)
        userImageView.sd_setImage(with: user?.photo?.urlThumb(), placeholderImage: nil)
        eventImageView.sd_setImage(with: event.photo?.urlThumb(), placeholderImage: nil)
    }
}

// MARK: - Actions
extension NotificationCell {
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
           for range in ranges {
            if gesture.didTapAttributedTextInLabel(label: label, targetRange: range) {
                   labelTapEvent?(label.text ?? "", range)
                   return
            }
        }
    }
}

// MARK: - Private Functions
extension NotificationCell {
    private func getFormattedString(string: String) -> NSAttributedString {
        ranges.removeAll()
        let scanner = Scanner(string: string)
        var strings = [String]()
        
        while !scanner.isAtEnd {
            var text: NSString?
            scanner.scanUpTo(startSeparator, into: nil)
            scanner.scanUpTo(endSeparator, into: &text)
            if let value = text {
                var valueWithoutSeparator = value.replacingOccurrences(of: startSeparator, with: "")
                valueWithoutSeparator = valueWithoutSeparator.replacingOccurrences(of: endSeparator, with: "")
                strings.append(valueWithoutSeparator)
            }
        }
        
        var stringWithoutSeparator = string.replacingOccurrences(of: startSeparator, with: "")
        stringWithoutSeparator = stringWithoutSeparator.replacingOccurrences(of: endSeparator, with: "")
        
        let pargraphStyle = NSMutableParagraphStyle()
        pargraphStyle.lineSpacing = 1.29

        let color1 = isDarkModeOn ? UIColor.buttonDisableTextColor : UIColor.bgBlack
        let attributes = [
            NSAttributedString.Key.foregroundColor: color1,
            NSAttributedString.Key.font: UIFont.regular(sz: 17.0),
            NSAttributedString.Key.paragraphStyle: pargraphStyle,
            NSAttributedString.Key.kern: -0.41] as [NSAttributedString.Key: Any]
        
        let color2 = isDarkModeOn ? UIColor.white : UIColor.bgBlack
        let attstr = NSMutableAttributedString(string: stringWithoutSeparator, attributes: attributes)

        let boldAttributes = [
            NSAttributedString.Key.foregroundColor: color2,
            NSAttributedString.Key.font: UIFont.medium(sz: 17.0)
        ]
        for text in strings {
            if let range = (stringWithoutSeparator as NSString).range(of: text) as NSRange? {
                attstr.setAttributes(boldAttributes, range: range)
                ranges.append(range)
            }
        }
        return attstr
    }
}
