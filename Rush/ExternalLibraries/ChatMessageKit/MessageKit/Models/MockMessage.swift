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
import Foundation
import CoreLocation
import SendBirdSDK

private struct CoordinateItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}

private struct ImageMediaItem: MediaItem {
    // New for event
    var time: Date?
    var title: String?
    var detail: String?
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
    init(title: String, detail: String, image: UIImage) {
        self.title = title
        self.detail = detail
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}

private struct EventMediaItem: EventItem {
    // New for event
    var time: Date?
    var eventTitle: String?
    var desc: String?
    var eventId: String?
    var eventDate: String?
    var eventMonth: String?
    var eventDay: String?
    var eventTime: String?
    var url: URL?
    var eventImageURL: URL?
    var placeholderImage: UIImage
    var size: CGSize
    
   /* init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    } */
    
    init(title: String, desc: String, imageUrl: URL?, eventId: String, eventDay: String, eventDate: String, eventMonth: String, eventTime: String) {
            self.eventTitle = title
            self.desc = desc
        self.eventImageURL = imageUrl
        self.eventId = eventId
        self.eventDay = eventDay
        self.eventDate = eventDate
        self.eventMonth = eventMonth
        self.eventTime = eventTime
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = #imageLiteral(resourceName: "placeholder-event48px")
        }
    
}

internal struct MockMessage: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(message: SBDBaseMessage) {
        // convert Int to Double
        let timeInterval = Double(message.createdAt)
        
        // create NSDate from Double (NSTimeInterval)
        let myNSDate = Date(timeIntervalSince1970: timeInterval/1000)
        
        if message.isKind(of: SBDUserMessage.self) {
            let userMessage = message as? SBDUserMessage
            let sender = Sender.init(id: (userMessage?.sender?.userId)!, displayName: (userMessage?.sender?.nickname)!, avatarUrl: userMessage?.sender?.profileUrl ?? "")
            if userMessage?.message?.contains("JSON_CHAT\":{\"type\":1") ?? false {
                //event message
                self.init(text: userMessage?.message ?? "", sender: sender, messageId: "\(message.messageId)", date: myNSDate)
                
                let jsonText = userMessage?.message
                if let data = jsonText?.data(using: String.Encoding.utf8) {
                    do {
                        if let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            
                            if let myDictionary = dictonary["JSON_CHAT"] as? [String: Any] {
                                print(" dict: \(myDictionary)")
                                // self.init(text: userMessage?.message ?? "", sender: 6sender, messageId: "\(message.messageId)", date: myNSDate)
                                let strurl = myDictionary["eventImage"] as? String ?? ""
                                let url = URL(string: strurl) ?? URL(string: "")
                                self.init(title: myDictionary["eventTitle"] as? String ?? "",
                                          detail: myDictionary["desc"] as? String ?? "",
                                          imageUrl: url,
                                          sender: sender,
                                          messageId: "\(message.messageId)",
                                          date: myNSDate,
                                          eventId: myDictionary["eventId"] as? String ?? "",
                                          eventDay: myDictionary["day"] as? String ?? "",
                                eventDate: myDictionary["date"] as? String ?? "",
                                eventMonth: myDictionary["month"] as? String ?? "",
                                eventTime: myDictionary["time"] as? String ?? "")
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
            } else {
                //text message
                self.init(text: userMessage?.message ?? "", sender: sender, messageId: "\(message.messageId)", date: myNSDate)
            }
            
        } else if message.isKind(of: SBDFileMessage.self) {
            let userMessage = message as? SBDFileMessage
            let sender = Sender.init(id: (userMessage?.sender?.userId)!, displayName: (userMessage?.sender?.nickname)!, avatarUrl: userMessage?.sender?.profileUrl ?? "")
            //            self.init(text: "", sender: sender, messageId: "\(message.messageId)", date: myNSDate)
            self.init(urlImage: URL(string: userMessage?.url ?? "")!, sender: sender, messageId: "\(message.messageId)", date: myNSDate)
        } else {
            self.init(text: "", sender: Sender(id: "", displayName: "", avatarUrl: ""), messageId: "", date: Date())
        }
    }
    
    init(custom: Any?, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .custom(custom), sender: sender, messageId: messageId, date: date)
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(urlImage: URL, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(url: urlImage)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(location: CLLocation, sender: Sender, messageId: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(emoji: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
    
    init(title: String, detail: String, imageUrl: URL?, sender: Sender, messageId: String, date: Date, eventId: String, eventDay: String, eventDate: String, eventMonth: String, eventTime: String) {
        let eventItem = EventMediaItem(title: title, desc: detail, imageUrl: imageUrl, eventId: eventId, eventDay: eventDay, eventDate: eventDate, eventMonth: eventMonth, eventTime: eventTime)
        self.init(kind: .event(eventItem), sender: sender, messageId: messageId, date: date)
    }
    
}
