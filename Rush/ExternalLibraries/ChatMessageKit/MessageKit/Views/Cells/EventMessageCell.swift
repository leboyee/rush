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
        
        mainView.fillSuperview()
        mainView.backgroundColor = .white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let top = imageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8)
        let bottom = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 138)
        let leading = imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8)
        let trailing = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)

        NSLayoutConstraint.activate([top, bottom, trailing, leading])
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(mainView)
        messageContainerView.addSubview(imageView)
        setupConstraints()
        
        let date = UILabel(frame: CGRect(x: 100, y: 8, width: 16, height: 16))
        date.text = "31"
        date.font = UIFont.Semibold(sz: 13)
        messageContainerView.addSubview(date)
        
        
        let month = UILabel(frame: CGRect(x: 120, y: 8, width: 200, height: 16))
        month.text = "JAN"
        month.textColor = UIColor.buttonDisableTextColor
        month.font = UIFont.Semibold(sz: 13)
        messageContainerView.addSubview(month)
        
        let day = UILabel(frame: CGRect(x: 100, y: 23, width: 61, height: 16))
        day.text = "Thursday"
        day.font = UIFont.Semibold(sz: 13)
        messageContainerView.addSubview(day)
        
        let time = UILabel(frame: CGRect(x: 165, y: 24, width: 200, height: 16))
        time.text = "10-12 pm"
        time.textColor = UIColor.buttonDisableTextColor
        time.font = UIFont.Semibold(sz: 13)
        messageContainerView.addSubview(time)
        
        let title = UILabel(frame: CGRect(x: 100, y: 53, width: screenWidth - 71 - 100, height: 28))
        title.text = "VR games"
        title.font = UIFont.DisplayBold(sz: 23)
        messageContainerView.addSubview(title)
        
        let detail = UILabel(frame: CGRect(x: 100, y: 89, width: screenWidth - 71 - 100, height: 54))
        detail.numberOfLines = 3
        detail.text = "Get the latest VR Experience with Samsung Gear. You can travel through the worlds as detail of UI thr samsung"
        detail.font = UIFont.Regular(sz: 13)
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
        case .event(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
        default:
            break
        }

        displayDelegate.configureMediaMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
    }
}
