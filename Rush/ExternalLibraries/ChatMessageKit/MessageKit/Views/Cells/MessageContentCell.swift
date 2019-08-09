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

/// A subclass of `MessageCollectionViewCell` used to display text, media, and location messages.
open class MessageContentCell: MessageCollectionViewCell {

    /// The image view displaying the avatar.
    open var avatarView = AvatarView()

    /// The container used for styling and holding the message's content view.
    open var messageContainerView: MessageContainerView = {
        let containerView = MessageContainerView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()

    /// The top label of the cell. (Time)
    open var cellTopLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// The top label of the messageBubble.
    open var messageTopLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        return label
    }()

    /// The bottom label of the messageBubble.
    open var messageBottomLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        return label
    }()
    
    var leftLine = UIView()
    var rightLine = UIView()

    // Should only add customized subviews - don't change accessoryView itself.
    open var accessoryView: UIView = UIView()

    /// The `MessageCellDelegate` for the cell.
    open weak var delegate: MessageCellDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }

    open func setupSubviews() {
        contentView.addSubview(accessoryView)
        contentView.addSubview(cellTopLabel)
        contentView.addSubview(messageTopLabel)
        contentView.addSubview(messageBottomLabel)
        contentView.addSubview(messageContainerView)
        contentView.addSubview(avatarView)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        cellTopLabel.text = nil
        messageTopLabel.text = nil
        messageBottomLabel.text = nil
    }

    // MARK: - Configuration

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        // Call this before other laying out other subviews
        layoutMessageContainerView(with: attributes)
        layoutBottomLabel(with: attributes)
        layoutCellTopLabel(with: attributes)
        layoutMessageTopLabel(with: attributes)
        layoutAvatarView(with: attributes)
        layoutAccessoryView(with: attributes)
    }

    /// Used to configure the cell.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` this cell displays.
    ///   - indexPath: The `IndexPath` for this cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell is contained.
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        delegate = messagesCollectionView.messageCellDelegate
        
         let messageStyle = displayDelegate.messageStyle(for: message, at: indexPath, in: messagesCollectionView)
        
        displayDelegate.configureAvatarView(avatarView, for: message, at: indexPath, in: messagesCollectionView)
        
        /*
        let messageColor = displayDelegate.backgroundColor(for: message, at: indexPath, in: messagesCollectionView)

        displayDelegate.configureAccessoryView(accessoryView, for: message, at: indexPath, in: messagesCollectionView)
        */
        
        
        if dataSource.isFromCurrentSender(message: message) {
            messageContainerView.backgroundColor = UIColor.white
        } else {
            if let _ = self as? EventMessageCell {
                messageContainerView.backgroundColor = UIColor.clear
            } else {
                messageContainerView.backgroundColor = UIColor.lightGray93
            }
        }
       
        messageContainerView.style = messageStyle

        let topCellLabelText = dataSource.cellTopLabelAttributedText(for: message, at: indexPath)
        let topMessageLabelText = dataSource.messageTopLabelAttributedText(for: message, at: indexPath)
        let bottomText = dataSource.messageBottomLabelAttributedText(for: message, at: indexPath)
        
        let widthOfString : CGFloat = 100
        
        let width = CGFloat(1)
        
        if topCellLabelText?.string.count ?? 0 > 0 {
            
            leftLine = UIView(frame: CGRect(x: 12, y: cellTopLabel.frame.height/2 - width/2, width: screenWidth/2 - 90, height: width))
            rightLine = UIView(frame: CGRect(x: cellTopLabel.frame.width/2 + widthOfString/2 + 15, y: cellTopLabel.frame.height/2 - width/2, width: screenWidth/2 - 80, height: width))
            
            cellTopLabel.attributedText = topCellLabelText
            
            leftLine.backgroundColor = UIColor.buttonDisableBgColor
            cellTopLabel.addSubview(leftLine)
            
            rightLine.backgroundColor = UIColor.buttonDisableBgColor
            cellTopLabel.addSubview(rightLine)
            
            leftLine.isHidden = false
            rightLine.isHidden = false
        } else {
            leftLine = UIView()
            rightLine = UIView()
            leftLine.backgroundColor = .clear
            rightLine.backgroundColor = .clear
            leftLine.isHidden = true
            rightLine.isHidden = true
            leftLine.removeFromSuperview()
            rightLine.removeFromSuperview()
        }

        cellTopLabel.attributedText = topCellLabelText
        messageTopLabel.attributedText = topMessageLabelText
        messageBottomLabel.attributedText = bottomText
    }

    /// Handle tap gesture on contentView and its subviews.
    open func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)

        switch true {
        case messageContainerView.frame.contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
            delegate?.didTapMessage(in: self)
        case avatarView.frame.contains(touchLocation):
            delegate?.didTapAvatar(in: self)
        case cellTopLabel.frame.contains(touchLocation):
            delegate?.didTapCellTopLabel(in: self)
        case messageTopLabel.frame.contains(touchLocation):
            delegate?.didTapMessageTopLabel(in: self)
        case messageBottomLabel.frame.contains(touchLocation):
            delegate?.didTapMessageBottomLabel(in: self)
        case accessoryView.frame.contains(touchLocation):
            delegate?.didTapAccessoryView(in: self)
        default:
            break
        }
    }

    /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint = gestureRecognizer.location(in: self)
        guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
        return messageContainerView.frame.contains(touchPoint)
    }

    /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return false
    }

    // MARK: - Origin Calculations

    /// Positions the cell's `AvatarView`.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutAvatarView(with attributes: MessagesCollectionViewLayoutAttributes) {
        var origin: CGPoint = .zero

        switch attributes.avatarPosition.horizontal {
        case .cellLeading:
            origin.x = 10
        case .cellTrailing:
            origin.x = attributes.frame.width - attributes.avatarSize.width
        case .natural:
            fatalError(MessageKitError.avatarPositionUnresolved)
        }

        switch attributes.avatarPosition.vertical {
        case .messageLabelTop:
            origin.y = messageTopLabel.frame.minY
        case .messageTop: // Needs messageContainerView frame to be set
            origin.y = messageContainerView.frame.minY
        case .messageBottom: // Needs messageContainerView frame to be set
            origin.y = messageContainerView.frame.maxY - attributes.avatarSize.height
        case .messageCenter: // Needs messageContainerView frame to be set
            origin.y = messageContainerView.frame.midY - (attributes.avatarSize.height/2)
        case .cellBottom:
            origin.y = messageContainerView.frame.maxY - attributes.avatarSize.height
        default:
            break
        }

        avatarView.frame = CGRect(origin: origin, size: attributes.avatarSize)
    }

    /// Positions the cell's `MessageContainerView`.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutMessageContainerView(with attributes: MessagesCollectionViewLayoutAttributes) {
        var origin: CGPoint = .zero

        switch attributes.avatarPosition.vertical {
        case .messageBottom:
            origin.y = attributes.size.height - attributes.messageContainerPadding.bottom - attributes.messageBottomLabelSize.height - attributes.messageContainerSize.height - attributes.messageContainerPadding.top
        case .messageCenter:
            if attributes.avatarSize.height > attributes.messageContainerSize.height {
                let messageHeight = attributes.messageContainerSize.height + attributes.messageContainerPadding.vertical
                origin.y = (attributes.size.height / 2) - (messageHeight / 2)
            } else {
                fallthrough
            }
        default:
            if attributes.accessoryViewSize.height > attributes.messageContainerSize.height {
                let messageHeight = attributes.messageContainerSize.height + attributes.messageContainerPadding.vertical
                origin.y = (attributes.size.height / 2) - (messageHeight / 2)
            } else {
                origin.y = attributes.cellTopLabelSize.height + attributes.messageTopLabelSize.height + attributes.messageContainerPadding.top
            }
        }

        switch attributes.avatarPosition.horizontal {
        case .cellLeading:
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left
        case .cellTrailing:
            origin.x = attributes.frame.width - attributes.avatarSize.width - attributes.messageContainerSize.width - attributes.messageContainerPadding.right
        case .natural:
            fatalError(MessageKitError.avatarPositionUnresolved)
        }

        messageContainerView.frame = CGRect(origin: origin, size: attributes.messageContainerSize)
    }

    /// Positions the cell's top label.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutCellTopLabel(with attributes: MessagesCollectionViewLayoutAttributes) {
        cellTopLabel.clipsToBounds = true
        cellTopLabel.frame = CGRect(origin: .zero, size: attributes.cellTopLabelSize)
    }
    
    /// Positions the message bubble's top label.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutMessageTopLabel(with attributes: MessagesCollectionViewLayoutAttributes) {
        messageTopLabel.textAlignment = attributes.messageTopLabelAlignment.textAlignment
        messageTopLabel.textInsets = attributes.messageTopLabelAlignment.textInsets

        let y = messageContainerView.frame.minY - attributes.messageContainerPadding.top - attributes.messageTopLabelSize.height
        let origin = CGPoint(x: 0, y: y)
        
        messageTopLabel.frame = CGRect(origin: origin, size: attributes.messageTopLabelSize)
    }

    /// Positions the cell's bottom label.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutBottomLabel(with attributes: MessagesCollectionViewLayoutAttributes) {
        messageBottomLabel.textAlignment = attributes.messageBottomLabelAlignment.textAlignment
        messageBottomLabel.textInsets = attributes.messageBottomLabelAlignment.textInsets

        let y = messageContainerView.frame.maxY + attributes.messageContainerPadding.bottom
        let origin = CGPoint(x: 0, y: y)

        messageBottomLabel.frame = CGRect(origin: origin, size: attributes.messageBottomLabelSize)
    }

    /// Positions the cell's accessory view.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutAccessoryView(with attributes: MessagesCollectionViewLayoutAttributes) {
        
        // Accessory view aligned to the middle of the messageContainerView
        let y = messageContainerView.frame.midY - (attributes.accessoryViewSize.height / 2)

        var origin = CGPoint(x: 0, y: y)

        // Accessory view is always on the opposite side of avatar
        switch attributes.avatarPosition.horizontal {
        case .cellLeading:
            origin.x = messageContainerView.frame.maxX + attributes.accessoryViewPadding.left
        case .cellTrailing:
            origin.x = messageContainerView.frame.minX - attributes.accessoryViewPadding.right - attributes.accessoryViewSize.width
        case .natural:
            fatalError(MessageKitError.avatarPositionUnresolved)
        }

        accessoryView.frame = CGRect(origin: origin, size: attributes.accessoryViewSize)
    }
}
