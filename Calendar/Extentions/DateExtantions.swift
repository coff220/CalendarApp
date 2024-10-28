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
    
    var firstWeekDayOfMonth: Int {
        let date = Date()
        let calendar = Calendar.current
        // Получаем номер дня недели (от 1 до 7)
        let weekday = calendar.component(.weekday, from: date)
        
        return weekday
    }
    
    var month: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM"
        return dateFormater.string(from: self)
    }
    
    var monthInt: Int {
        let components = Calendar.current.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    var year: Int {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    static func nextMonth (after date: Date) -> Date {
        let nextMonth = Calendar.current.date(byAdding: .month, value: +1, to: date)
        return nextMonth ?? date
    }
    
    static func previousMonth (before date: Date) -> Date {
        let previosMonth = Calendar.current.date(byAdding: .month, value: -1, to: date)
        return previosMonth ?? date
    }
}

