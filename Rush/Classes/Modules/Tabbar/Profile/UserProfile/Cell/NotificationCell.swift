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
    var userImageTapEvent:(() -> Void)?
    var eventImageTapEvent:(() -> Void)?

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
    
    func set(object: Any?, text: String) {
        
        var key = ""
        var value = ""
        var photo: Image?
        var placeholderMain = ""
        if let club = object as? Club {
            key = "{club_name}"
            value = startSeparator + (club.clubName ?? "") + endSeparator
            photo = club.photo
            placeholderMain = "placeholder-club48px"
        } else if let event = object as? Event {
            key = "{event_name}"
            value = startSeparator + event.title + endSeparator
            photo = event.photo
            placeholderMain = "placeholder-event48px"
        } else if let classObject = object as? SubClass {
            key = "{class_name}"
            value = startSeparator + classObject.name + endSeparator
            photo = classObject.photo
            placeholderMain = "placeholder-classChat-#1"
        } else if let user = object as? User {
            key = "{friend_user_name}"
            value = startSeparator + user.name + endSeparator
            photo = user.photo
            placeholderMain = "placeholder-profile-48px"
        }
        
        let detailText = text.replacingOccurrences(of: key, with: value)
        label.attributedText = getFormattedString(string: detailText)
        userImageView.sd_setImage(with: photo?.urlThumb(), placeholderImage: UIImage(named: placeholderMain))
        eventImageView.sd_setImage(with: Authorization.shared.profile?.photo?.urlThumb(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-32px.pdf"))
    }
    
    func set(user: User?, object: Any?, text: String) {
        let userName = "{user_name}"
        let name = startSeparator + (user?.name ?? "") + endSeparator
        
        var key = ""
        var value = ""
        var photo: Image?
        var placeholderSmall = ""
        if let club = object as? Club {
            key = "{club_name}"
            value = startSeparator + (club.clubName ?? "") + endSeparator
            photo = club.photo
            placeholderSmall = "placeholder-club48px"
        } else if let event = object as? Event {
            key = "{event_name}"
            value = startSeparator + event.title + endSeparator
            photo = event.photo
            placeholderSmall = "placeholder-event48px"
        } else if let classObject = object as? SubClass {
            key = "{class_name}"
            value = startSeparator + classObject.name + endSeparator
            photo = classObject.photo
            placeholderSmall = "placeholder-classChat-#1"
        }
        
        var detailText = text.replacingOccurrences(of: userName, with: name)
        detailText = detailText.replacingOccurrences(of: key, with: value)
        
        label.attributedText = getFormattedString(string: detailText)
        userImageView.sd_setImage(with: user?.photo?.urlThumb(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-48px.pdf"))
        eventImageView.sd_setImage(with: photo?.urlThumb(), placeholderImage: UIImage(named: placeholderSmall))
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
    
    @IBAction func eventImageButtonAction() {
        eventImageTapEvent?()
    }
    
    @IBAction func userImageButtonAction() {
        userImageTapEvent?()
    }
}

// MARK: - Private Functions
extension NotificationCell {
    private func getFormattedString(string: String) -> NSAttributedString {
        let text = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        ranges.removeAll()
        let scanner = Scanner(string: text)
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
