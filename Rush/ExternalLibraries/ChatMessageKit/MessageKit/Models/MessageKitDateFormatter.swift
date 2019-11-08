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

import Foundation

open class MessageKitDateFormatter {

    // MARK: - Properties

    public static let shared = MessageKitDateFormatter()

    private let formatter = DateFormatter()

    // MARK: - Initializer

    private init() {}

    // MARK: - Methods

    public func string(from date: Date) -> String {
        configureDateFormatter(for: date)
        return formatter.string(from: date)
    }

    public func attributedString(from date: Date, with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let dateString = string(from: date)
        return NSAttributedString(string: dateString, attributes: attributes)
    }

    open func configureDateFormatter(for date: Date) {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        switch true {
        case Calendar.current.isDateInToday(date):
            formatter.dateFormat = "'Today' '|' h a"
        case Calendar.current.isDateInYesterday(date):
            formatter.dateFormat = "'Yesterday' '|' h a"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            formatter.dateFormat = "dd MMM '|' h a"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
            formatter.dateFormat = "dd MMM '|' h a"/*"E, d MMM, h:mm a"*/
        default:
            formatter.dateFormat = "dd MMM '|' h a"/*"MMM d, yyyy, h:mm a"*/
        }
    }
    
}
