//
//  DateExtantions.swift
//  Calendar
//
//  Created by Viacheslav on 11/10/2024.
//

import Foundation

extension Date {
    var daysInMonth: Int {
        var components = Calendar.current.dateComponents([.month], from: self)
        var nextMonth = 0
        if let currentMounth = components.month {
            if currentMounth < 12 {
                nextMonth = currentMounth + 1
            } else {
                nextMonth = 1
            }
        }
        components.day = 1
        components.month = nextMonth
        let oneDayInterval = TimeInterval(60 * 60 * 24)
        let lastDeyOfThisMonth = Calendar.current.date(from: components)! - oneDayInterval
        let lastComponents = Calendar.current.dateComponents([.day], from: lastDeyOfThisMonth)
        return lastComponents.day ?? 0
    }
    
    var currentMonth: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM"
        return dateFormater.string(from: self)
    }
    
    var stringDay: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d"
        return dateFormater.string(from: self)
    }
    
    var numberOfCurrentMonth: Int {
        let components = Calendar.current.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    var year: Int {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    func startOfMonth() -> Date {
        let interval = Calendar.current.dateInterval(of: .month, for: self)
        return (interval?.start.toLocalTime())! // Without toLocalTime it give last months last date
      }
      
      func toLocalTime() -> Date {
          let timezone = TimeZone.current
          let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
          return Date(timeInterval: seconds, since: self)
      }

    func day(after day: Int) -> Date {
        let nextDay = Calendar.current.date(byAdding: .day, value: day, to: self)
        return nextDay ?? self
    }
    
    func intervalStartOfDay() -> Double {
        let interval = Calendar.current.dateInterval(of: .day, for: self)
        let test: Double = interval?.start.timeIntervalSince1970 ?? 0
        return test
    }
    
    func intervalEndOfDay() -> Double {
        let interval = Calendar.current.dateInterval(of: .day, for: self)
        let test: Double = interval?.end.timeIntervalSince1970 ?? 0
        return test
    }
    
    static func nextMonth(after date: Date) -> Date {
        let nextMonth = Calendar.current.date(byAdding: .month, value: +1, to: date)
        return nextMonth ?? date
    }
    
    static func previousMonth(before date: Date) -> Date {
        let previosMonth = Calendar.current.date(byAdding: .month, value: -1, to: date)
        return previosMonth ?? date
    }
}
    
