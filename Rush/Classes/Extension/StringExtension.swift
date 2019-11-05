//
//  StringExtension.swift
//  Rush
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//
import Foundation
import UIKit

extension String {
    var isValidEmailAddress: Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let linkDetector = try? NSDataDetector(types: types.rawValue)
        let range = NSRange(location: 0, length: self.count)
        let result = linkDetector?.firstMatch(in: self, options: .reportCompletion, range: range)
        let scheme = result?.url?.scheme ?? ""
        return scheme == "mailto" && result?.range.length == self.count
    }
    
    var isValidEmailAddressString: Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 .@_%+-].*", options: .caseInsensitive)
            if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.count)) == nil {
                return true
            }

        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
    
    var isValidNameString: Bool {
          do {
              let regex = try NSRegularExpression(pattern: ".*[^0-9].*", options: .caseInsensitive)
              if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.count)) != nil {
                  return true
              }

          } catch {
              debugPrint(error.localizedDescription)
              return false
          }
          return false
      }
        
    //The password must be at least 6 characters and must include at least one upper and lower case letter.
    var isValidPassword: Bool {
        let pattern = "^(?=.*[a-z])(?=.*[A-Z])[A-Za-z\\d$@$!%*#?&]{6,}$"
        if let regex = try? NSRegularExpression(pattern: pattern) {
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        }
        return false
    }
    
    var isCapitalLater: Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        return capitalresult
    }
    
    var isNumberLater: Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberresult = texttest.evaluate(with: self)
        return numberresult
    }
        
    var isValidPhoneNumber: Bool {
        let pattern = "^\\(*\\+*[1-9]{0,3}\\)*-*[1-9]{0,3}[-. /]*\\(*[2-9]\\d{2}\\)*[-. /]*\\d{3}[-. /]*\\d{4} *e*x*t*\\.* *\\d{0,4}$"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            if results.count == 1, let phone = results.map({ nsString.substring(with: $0.range) }).first {
                if phone.count == self.count {
                    return true
                }
            }
            return false
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    var inPhoneNumber: String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    var inPhoneNumberWithDash: String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "-$1-$2-$3", options: .regularExpression, range: nil)
    }
    
    var phoneNumberWithoutFormat: String {
        return replacingOccurrences(of: "[ |()-]", with: "", options: [.regularExpression])
    }
    
    var isLink: Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard detector != nil && self.count > 0 else { return false }
        let range = NSRange(location: 0, length: self.count)
        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: range) > 0 {
            return true
        }
        return false
    }
    
    var inCurrency: String {
        guard self.count > 0 else { return "$0.00" }
        guard let doubleValue = Double(self) else { return "$0.00" }
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currencyAccounting
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "$\(doubleValue)"
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var inNumber: String {
        guard self.count > 0 else { return "0" }
        guard let doubleValue = Double(self) else { return "0" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "0"
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
    }
    
    var isAlphabates: Bool {
        return !isEmpty && range(of: "[^a-zA-Z ]", options: .regularExpression) == nil
    }
    
    var valueWithoutCurrency: String {
        var price = self.replacingOccurrences(of: ",", with: "")
        price = price.replacingOccurrences(of: "$", with: "")
        return price
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    var smallName: String {
        let fullName = self
        var components = fullName.components(separatedBy: " ")
        var name = ""
        if components.count > 0 {
            let firstName = components.removeFirst()
            let lastName = components.joined(separator: " ")
            
            let lastnameCh = lastName.map { String($0) }
            name = firstName
            if lastnameCh.count > 0 {
                name = firstName + " " + (lastnameCh.first ?? "")
            }
        }
        return name
    }
    
    var firstName: String {
        var fullname = self
        let allValue = fullname.components(separatedBy: " ")
        if allValue.count > 0 {
            fullname = allValue.first ?? fullname
        }
        return fullname
    }
}

extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

extension StringProtocol {
    func nsRange(from range: Range<Index>) -> NSRange {
        return .init(range, in: self)
    }
}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? UIFont.semibold(sz: 17)], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

// MARK: - String extension for images
extension String {
    var photos: [Image]? {
        if let data = self.data(using: .utf8) {
            var images = [Image]()
            do {
                if let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                    for img in object {
                        images.append(Image(data: img))
                    }
                    return images
                } else {
                    print("Error in json : " + self)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    var photo: Image? {
        if let data = self.data(using: .utf8) {
            do {
                if let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    return Image(data: object)
                } else {
                    print("Error in json : " + self)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
