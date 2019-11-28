/*
 MIT License

 Copyright (c) 2017-2018 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class EventMessageCell: MessageContentCell {

    var eventId: String?
    var eventTitle: String?
    var eventDesc: String?
    var eventDate: String?
    var eventMonth: String?
    var eventDay: String?
    var eventTime: String?
    
    /// The image view display the media content.
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    open var mainView: UIView = {
        return UIView()
    }()

    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        
//        mainView.fillSuperview()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
            mainView.topAnchor.constraint(equalTo: mainView.superview!.topAnchor, constant: 0),
            mainView.leadingAnchor.constraint(equalTo: mainView.superview!.leadingAnchor, constant: 15),
            mainView.bottomAnchor.constraint(equalTo: mainView.superview!.bottomAnchor, constant: 50),
            mainView.trailingAnchor.constraint(equalTo: mainView.superview!.trailingAnchor, constant: 0)
            ]
        )
        
        messageContainerView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let top = imageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8)
        let bottom = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 138)
        let leading = imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 5)
        let trailing = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)

        NSLayoutConstraint.activate([top, bottom, trailing, leading])
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(mainView)
        messageContainerView.addSubview(imageView)
        setupConstraints()
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 24
        mainView.clipsToBounds = true
        
        messageContainerView.layer.cornerRadius = 24
        
        let date = UILabel(frame: CGRect(x: 112, y: 8, width: 18, height: 20))
        date.text = eventDate ?? "31"
        date.font = UIFont.semibold(sz: 13)
        messageContainerView.addSubview(date)
        
        let month = UILabel(frame: CGRect(x: 140, y: 10, width: 200, height: 16))
        month.text = eventMonth ?? "JAN"
        month.textColor = UIColor.buttonDisableTextColor
        month.font = UIFont.semibold(sz: 13)
        messageContainerView.addSubview(month)
        
        let dayWidth = (eventDay?.count ?? 0) < 5 ? 22 : 61
        
        let day = UILabel(frame: CGRect(x: 112, y: 25, width: dayWidth, height: 16))
        day.text = eventDay ?? "Sunday"
        day.font = UIFont.semibold(sz: 13)
        day.sizeToFit()
        messageContainerView.addSubview(day)
                
        let time = UILabel(frame: CGRect(x: day.frame.maxX + 5, y: (eventDay?.count ?? 0) < 5 ? 27 : 25, width: 200, height: 16))
        time.text = eventTime ?? "10-12 pm"
        time.textColor = UIColor.buttonDisableTextColor
        time.font = UIFont.semibold(sz: (eventDay?.count ?? 0) < 5 ? 10 : 13)
        messageContainerView.addSubview(time)
        
        let title = UILabel(frame: CGRect(x: 112, y: 53, width: screenWidth - 71 - 100 - 15, height: 28))
        title.text = eventTitle ?? "VR games"
        title.font = UIFont.displayBold(sz: 23)
        messageContainerView.addSubview(title)
        
        let detail = UILabel(frame: CGRect(x: 112, y: 89, width: screenWidth - 71 - 100 - 15, height: 54))
        detail.numberOfLines = 3
        detail.text = eventDesc ?? "Get the latest VR Experience with Samsung Gear. You can travel through the worlds as detail of UI thr samsung"
        detail.font = UIFont.regular(sz: 13)
        messageContainerView.addSubview(detail)
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
       guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        switch message.kind {
        case .photo(let mediaItem):
            if  mediaItem.url != nil {
              imageView.sd_setImage(with: mediaItem.url, completed: nil)
            } else {
                imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            }
        case .video(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
        case .event(let eventItem):
            imageView.sd_setImage(with: eventItem.eventImageURL, placeholderImage: eventItem.placeholderImage)
            eventTitle = eventItem.eventTitle
            eventDesc = eventItem.desc
            eventDay = eventItem.eventDay
            eventDate = eventItem.eventDate
            eventMonth = eventItem.eventMonth
            eventTime = eventItem.eventTime
            setupSubviews()
        default:
            break
        }

        displayDelegate.configureMediaMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
    }
}
