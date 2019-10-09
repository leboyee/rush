//
//  DateExtension.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import Foundation

extension Date {
    public func plus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func minus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func plus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    public func minus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    public func plus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    public func minus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    public func plus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    public func minus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    fileprivate func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        var dc = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return Calendar.current.date(byAdding: dc, to: self as Date)!
    }
    
    public func midnightUTCDate() -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self as Date)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: dc)!
    }
    
    public func midnightDate() -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self as Date)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        return Calendar.current.date(from: dc)!
    }

    public func localToUTC(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        if let newDate = dateFormatter.date(from: date) {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            newDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return newDateFormatter.string(from: newDate)
        }
        return dateFormatter.string(from: Date())
    }
    
    public func localToUTCDate(date: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
           dateFormatter.calendar = NSCalendar.current
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
           if let newDate = dateFormatter.date(from: date) {
               let newDateFormatter = DateFormatter()
               newDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
               return newDateFormatter.string(from: newDate)
           }
           return dateFormatter.string(from: Date())
       }
    
    static func getCurrentTimeHours(date: Date) -> String {
        let hour = date.hour
        let min = date.minute
        let second = date.second
        let time = String(format: "%02d:%02d:%02d", hour, min, second)
        return time
    }

    public func UTCToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let newDate = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: newDate ?? Date())
    }
    
    public static func secondsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.second], from: d1, to: d2)
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.day], from: d1, to: d2)
        return dc.day!
    }
    
    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.month], from: d1, to: d2)
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.year], from: d1, to: d2)
        return dc.year!
    }
    
    // MARK: - Comparison Methods
    public func isGreaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }
    
    public func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    public func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    public func isTomorrow() -> Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    // MARK: - Computed Properties
    public var day: UInt {
        return UInt(Calendar.current.component(.day, from: self as Date))
    }
    
    public var month: UInt {
        return UInt(NSCalendar.current.component(.month, from: self as Date))
    }
    
    public var year: UInt {
        return UInt(NSCalendar.current.component(.year, from: self as Date))
    }
    
    public var hour: UInt {
        return UInt(NSCalendar.current.component(.hour, from: self as Date))
    }
    
    public var minute: UInt {
        return UInt(NSCalendar.current.component(.minute, from: self as Date))
    }
    
    public var second: UInt {
        return UInt(NSCalendar.current.component(.second, from: self as Date))
    }
    
    // returns from 1 - 7, with 1 being Sunday and 7 being Saturday
    public var weekday: UInt {
        return UInt(NSCalendar.current.component(.weekday, from: self as Date))
    }
    
    public var weekOfYear: UInt {
        return UInt(NSCalendar.current.component(.weekOfYear, from: self as Date))
    }
    
    public var daysInMonth: UInt {
        let range = NSCalendar.current.range(of: .day, in: .month, for: self as Date)
        return UInt(range!.count)
    }
    
    public var dayOfYear: UInt {
        let range = NSCalendar.current.range(of: .day, in: .year, for: self as Date)
        return UInt(range!.count)
    }
    
    public var age: Int {
        let age = Date.yearsBetween(date1: self, date2: Date())
        return age
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    // MARK: - Compute Date as String
    public func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
    // MARK: - Class Functions
    static func parse(dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
    
    public func convertDateToDate(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return formatter.date(from: dateString) ?? Date()
    }
    
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!
        
        return TimeInterval(dateSeconds)
    }
    
    // Interval between two times of the day in seconds
    static func timeOfDayInterval(date: Date) -> TimeInterval {
        let date1Seconds = Date().secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }
    
    func standardServerFormatterDateFromString(dateString: String) -> Date {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        return timeFormatter.date(from: dateString)!
    }
    
    func timeAgoDisplay(date: Date) -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < date {
            return "Now"
        } else if hourAgo < date {
            let formatter = DateFormatter()
            formatter.dateFormat = "h a"
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            return formatter.string(from: date)
        } else if dayAgo < date {
            let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < date {
            let diff = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: date, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}
