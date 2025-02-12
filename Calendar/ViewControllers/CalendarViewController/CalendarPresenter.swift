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
    func isCurrentMonth() -> Bool
    
    var delegate: CalendarViewControllerProtocol? { get set }
}

class CalendarPresenter: CalendarPresenterProtocol {
    
    private var currentDate = Date()
    private let calendar = Calendar.current
    private var calendarDay: [CalendarDay] = []
    private var reminders = DataBase.share.fetchReminders()
    weak var delegate: CalendarViewControllerProtocol?
    
    func isSundayFirstDayOfWeek() -> Bool {
        calendar.firstWeekday == 1 ? true : false
    }
  
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
    
    func countItems() -> Int {
        calendarDay.count
    }
    
    func monthYearText() -> String {
        " \(currentDate.currentMonth) \(currentDate.year) "
    }
    
    func isCurrentMonth() -> Bool {
        return !isDateInCurrentMonth(currentDate)
    }
    
    func weekDays() -> [String?] {
        let symbols = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        let firstSlice = symbols[firstWeekdayIndex..<symbols.count]
        let secondSlice = symbols[0..<firstWeekdayIndex]
        
        return Array(firstSlice) + Array(secondSlice)
    }
    
    // номер первого дня недели в текущем месяце
    func firstWeekDayOfMonth() -> Int {
        let dateComponents = DateComponents(year: currentDate.year, month: currentDate.numberOfCurrentMonth, day: 1)
        if let firstDayOfMonth = calendar.date(from: dateComponents) {
            let dayOfWeekSunday = calendar.component(.weekday, from: firstDayOfMonth)
            let dayOfWeakMonday = dayOfWeekSunday == 1 ? 7 : dayOfWeekSunday - 1
            
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
    }
    
    func today() -> Int {
        return calendar.component(.day, from: currentDate)
    }
    
    func updateCurrentMonth() {
        updateCalendarDays()
        delegate?.reloadData()
    }
    
    func isDateInCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month], from: Date())
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        
        return currentComponents.year == dateComponents.year &&
               currentComponents.month == dateComponents.month
    }
}

private extension CalendarPresenter {
    
    func cellTextColor(date: Date) -> UIColor {
        var color: UIColor!
        
        if date.isInCurrentMonth(date: currentDate) {
            color = .mainDigit
        } else {
            color = .weekdayShadow
        }
        
        if date.isWeekend() {
            if !Date().isDateToday(date: date) {
                color = .mainPurple
            } else {
                color  = .mainDigit
            }
            
            if !date.isInCurrentMonth(date: currentDate) {
                color =  .weekendShadow
            }
        }
        
        return color
    }
    
    func updateCalendarDays() {
        calendarDay.removeAll()

        let daysBeforeFirstDayOfMonth = firstWeekDayOfMonth() - 1
        // количество ячеек в коллекшнвью
       
        var currentDateArraySize: Int {
            if daysBeforeFirstDayOfMonth + currentDate.daysInMonth == 28 {
                return 28
            } else  if daysBeforeFirstDayOfMonth + currentDate.daysInMonth <= 35 {
                return 35
            } else {
                return 42
            }
        }
        
        for i in -(daysBeforeFirstDayOfMonth)...(currentDateArraySize - daysBeforeFirstDayOfMonth - 1) {
            let date = currentDate.startOfMonth().day(after: i)
            let day = CalendarDay(
                title: date.stringDay,
                isToday: Date().isDateToday(date: date),
                isActive: DataBase.share.getReminders(date: date),
                date: date, 
                textColor: cellTextColor(date: date)
            )
            calendarDay.append(day)
        }
    }
}
