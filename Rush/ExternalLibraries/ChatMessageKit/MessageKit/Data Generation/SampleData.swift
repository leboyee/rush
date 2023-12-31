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

import CoreLocation
import UIKit

final internal class SampleData {
    
    static let shared = SampleData()
    
    private init() {}
    
    enum MessageTypes: UInt32, CaseIterable {
        case textC = 0
        case attributedTextC = 1
        case photoC = 2
        case videoC = 3
        case emojiC = 4
        case locationC = 5
        case urlC = 6
        case phoneC = 7
        case customC = 8
        case eventC = 9
        
        static func random() -> MessageTypes {
            // Update as new enumerations are added
            let maxValue = customC.rawValue
            
            let rand = arc4random_uniform(maxValue+1)
            return MessageTypes(rawValue: rand)!
        }
    }
    
    let system = Sender(id: "000000", displayName: "System", avatarUrl: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")
    let nathan = Sender(id: "000001", displayName: "Nathan Tannar", avatarUrl: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")
    let steven = Sender(id: "000002", displayName: "Steven Deutsch", avatarUrl: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")
    let wu = Sender(id: "000003", displayName: "Wu Zhong", avatarUrl: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")
    
    lazy var senders = [nathan, steven, wu]
    
    var currentSender: Sender {
        return nathan
    }
    
    var now = Date()
    
    let messageImages: [UIImage] = [UIImage(named: "test-event-bg")!, UIImage(named: "test-event-bg")!]
    
    let emojis = [
        "👍",
        "😂😂😂",
        "👋👋👋",
        "😱😱😱",
        "😃😃😃",
        "❤️"
    ]
    
    let attributes = ["Font1", "Font2", "Font3", "Font4", "Color", "Combo"]
    
    let locations: [CLLocation] = [
        CLLocation(latitude: 37.3118, longitude: -122.0312),
        CLLocation(latitude: 33.6318, longitude: -100.0386),
        CLLocation(latitude: 29.3358, longitude: -108.8311),
        CLLocation(latitude: 39.3218, longitude: -127.4312),
        CLLocation(latitude: 35.3218, longitude: -127.4314),
        CLLocation(latitude: 39.3218, longitude: -113.3317)
    ]
    
    func attributedString(with text: String) -> NSAttributedString {
        let nsString = NSString(string: text)
        var mutableAttributedString = NSMutableAttributedString(string: text)
        let randomAttribute = Int(arc4random_uniform(UInt32(attributes.count)))
        let range = NSRange(location: 0, length: nsString.length)
        
        switch attributes[randomAttribute] {
        case "Font1":
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: range)
        case "Font2":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: range)
        case "Font3":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Font4":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Color":
            mutableAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: range)
        case "Combo":
            let msg9String = "Use .attributedText() to add bold, italic, colored text and more..."
            let msg9Text = NSString(string: msg9String)
            let msg9AttributedText = NSMutableAttributedString(string: String(msg9Text))
            
            msg9AttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSRange(location: 0, length: msg9Text.length))
            let font = UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: font], range: msg9Text.range(of: ".attributedText()"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "bold"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "italic"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: msg9Text.range(of: "colored"))
            mutableAttributedString = msg9AttributedText
        default:
            fatalError("Unrecognized attribute for mock message")
        }
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    
    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }
    
    func randomMessageType() -> MessageTypes {
//        let messageType = MessageTypes.random()
//
//        if !UserDefaults.standard.bool(forKey: "\(messageType)" + " Messages") {
//            return randomMessageType()
//        }
        
        return .textC
    }
    
    func randomMessage(allowedSenders: [Sender]) -> MockMessage {
        
        let randomNumberSender = Int(arc4random_uniform(UInt32(allowedSenders.count)))
        
        let uniqueID = NSUUID().uuidString
        let sender = allowedSenders[randomNumberSender]
        let date = dateAddingRandomTime()
        
        switch randomMessageType() {
        case .textC:
            let randomSentence = Lorem.sentence()
            return MockMessage(text: randomSentence, sender: sender, messageId: uniqueID, date: date)
        case .attributedTextC:
            let randomSentence = Lorem.sentence()
            let attributedText = attributedString(with: randomSentence)
            return MockMessage(attributedText: attributedText, sender: senders[randomNumberSender], messageId: uniqueID, date: date)
        case .photoC:
            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
            let image = messageImages[randomNumberImage]
            return MockMessage(image: image, sender: sender, messageId: uniqueID, date: date)
        case .videoC:
            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
            let image = messageImages[randomNumberImage]
            return MockMessage(thumbnail: image, sender: sender, messageId: uniqueID, date: date)
        case .emojiC:
            let randomNumberEmoji = Int(arc4random_uniform(UInt32(emojis.count)))
            return MockMessage(emoji: emojis[randomNumberEmoji], sender: sender, messageId: uniqueID, date: date)
        case .locationC:
            let randomNumberLocation = Int(arc4random_uniform(UInt32(locations.count)))
            return MockMessage(location: locations[randomNumberLocation], sender: sender, messageId: uniqueID, date: date)
        case .urlC:
            return MockMessage(text: "https://github.com/MessageKit", sender: sender, messageId: uniqueID, date: date)
        case .phoneC:
            return MockMessage(text: "123-456-7890", sender: sender, messageId: uniqueID, date: date)
        case .customC:
            return MockMessage(custom: "Someone left the conversation", sender: system, messageId: uniqueID, date: date)
        case .eventC:
//            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
//            let image = messageImages[randomNumberImage]
            return MockMessage(title: "31 JAN", detail: "Thursday", imageUrl: URL(string: "")!, sender: system, messageId: uniqueID, date: date, eventId: "1", eventDay: "Mon", eventDate: "32", eventMonth: "JAN", eventTime: "12")
        }
    }
    
    func getMessages(count: Int, isGroupChat: Bool, completion: ([MockMessage]) -> Void) {
        let messages: [MockMessage] = []
        completion(messages)
        return
        /*
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for index in 0..<count {
            var message = randomMessage(allowedSenders: senders)
            if index == 19 && isGroupChat {
//                let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
//                let image = messageImages[randomNumberImage]
                message = MockMessage(title: "", detail: "", imageUrl: URL(string: "")!, sender: senders.last!, messageId: NSUUID().uuidString, date: dateAddingRandomTime(), eventId: "1", eventDay: "Mon", eventDate: "32", eventMonth: "JAN", eventTime: "12")
            }
            messages.append(message)
        }
        completion(messages)
        */
    }
    
    func getAdvancedMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Enable Custom Messages
        UserDefaults.standard.set(true, forKey: "Custom Messages")
        for _ in 0..<count {
            let message = randomMessage(allowedSenders: senders)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getMessages(count: Int, allowedSenders: [Sender], completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let message = randomMessage(allowedSenders: allowedSenders)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getAvatarFor(sender: Sender) -> Avatar {
        
        if sender.avatarUrl.isEmpty {
            let firstName = sender.displayName.components(separatedBy: " ").first
            let lastName = sender.displayName.components(separatedBy: " ").first
            let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
            return Avatar(image: nil, initials: initials)
        } else {
            return Avatar(image: nil, initials: "", imageUrl: sender.avatarUrl)
        }
    }
    
}
