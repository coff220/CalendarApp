//
//  CalendarPresenter.swift
//  Calendar
//
//  Created by Viacheslav on 13/10/2024.
//

import Foundation
import UIKit

protocol CalendarPresenterProtocol: AnyObject {
    func nextMonthDidTap()
    func previousMonthDidTap()
    func todayDidTap()
    func countItems() -> Int
    func monthYearText() -> String
    func weekDays() -> [String?]
    func firstWeekDayOfMonth() -> Int
    func item(at index: Int) -> CalendarDay
    func viewDidLoad()
    func today() -> Int
    func updateCurrentMonth()
    func isSundayFirstDayOfWeek() -> Bool
    
    var delegate: CalendarViewControllerProtocol? { get set }
}

class CalendarPresenter: CalendarPresenterProtocol {
    
    private var currentDate = Date()
    private let calendar = Calendar.current
    private var dateComponents = DateComponents()
    private let dateFormatter = DateFormatter()
    private var calendarDay: [CalendarDay] = []
    
    func isSundayFirstDayOfWeek() -> Bool {
        let firstWeekday = calendar.firstWeekday
        switch firstWeekday {
        case 1:
            print("Sunday is the first day of the week.")
            return true
        case 2:
            print("Monday is the first day of the week.")
            return false
        default:
            // In some locales it can be something else (e.g., Saturday = 7, etc.)
            print("The first day of the week is neither Sunday nor Monday. It's day number \(firstWeekday) in this locale.")
            return true
        }
    }
    weak var delegate: CalendarViewControllerProtocol?
    
    func nextMonthDidTap() {
        currentDate = Date.nextMonth(after: currentDate)
        updateCurrentMonth()
    }
    
    func previousMonthDidTap() {
        currentDate = Date.previousMonth(before: currentDate)
        updateCurrentMonth()
    }
    
    func todayDidTap() {
        currentDate = Date()
        updateCurrentMonth()
    }
    
    // количество ячеек в CollectionView
    func countItems() -> Int {
        calendarDay.count
    }
    
    // текст для monthLabel
    func monthYearText() -> String {
        " \(currentDate.currentMonth) \(currentDate.year) "
    }
    
    // названия дней недели для weekDaysStackView
    func weekDays() -> [String?] {
        // Get the standard localized weekday symbols
        let symbols = calendar.shortWeekdaySymbols
        
        // "weekdaySymbols" is typically indexed with Sunday=0, Monday=1, etc.
        // But "calendar.firstWeekday" is typically 1 for Sunday, 2 for Monday, etc.
        // We can align these indices by shifting the array.
        
        // firstWeekday is 1-based; convert to 0-based by subtracting 1
        let firstWeekdayIndex = calendar.firstWeekday - 1
        
        // Separate the array into two slices and re-append
        let firstSlice = symbols[firstWeekdayIndex..<symbols.count]
        let secondSlice = symbols[0..<firstWeekdayIndex]
        
        // Combine into the final array
        return Array(firstSlice) + Array(secondSlice)
        
    }
    
    // номер первого дня недели в текущем месяце [первый день недели воскресенье, первый день недели понедельник]
    func firstWeekDayOfMonth() -> Int {
        dateComponents = DateComponents(year: currentDate.year, month: currentDate.numberOfCurrentMonth, day: 1)
        if let firstDayOfMonth = calendar.date(from: dateComponents) {
            let dayOfWeekSunday = calendar.component(.weekday, from: firstDayOfMonth)
            
            var dayOfWeakMonday: Int
            if dayOfWeekSunday == 1 {
                dayOfWeakMonday = 7
            } else {
                dayOfWeakMonday = dayOfWeekSunday - 1
            }
            
            if isSundayFirstDayOfWeek() {
                return dayOfWeekSunday
            } else {
                return dayOfWeakMonday
            }
            
        } else {
            return 1
        }
    }
    
    func item(at index: Int) -> CalendarDay {
        return calendarDay[index]
    }
    
    func viewDidLoad() {
        updateCalendarDays()
        print(currentDate.stringDay)
    }
    
    // сегодняшнее число
    func today() -> Int {
        let today = calendar.component(.day, from: currentDate)
        return today
    }
    
    func updateCurrentMonth() {
        updateCalendarDays()
        delegate?.reloadData()
    }
}

private extension CalendarPresenter {
    
    func updateCalendarDays() {
        calendarDay.removeAll()
        
        if firstWeekDayOfMonth() > 1 {
            for _ in 1...firstWeekDayOfMonth() - 1 {
                let day = CalendarDay(
                    title: "",
                    isToday: false,
                    isActive: false,
                    date: currentDate
                )
                calendarDay.append(day)
            }
        }
        
        for i in 0...currentDate.daysInMonth - 1 {
            let date = currentDate.startOfMonth().day(after: i)
            let day = CalendarDay(
                title: date.stringDay,
                isToday: Date().isDateToday(date: date),
                isActive: DataBase.share.getReminders(date: date),
                date: date
            )
            calendarDay.append(day)
        }
    }
}
