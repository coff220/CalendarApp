//
//  CalendarPresenter.swift
//  Calendar
//
//  Created by Viacheslav on 13/10/2024.
//

import Foundation

protocol CalendarPresenterProtocol: AnyObject {
    func nextMonthDidTap()
    func previousMonthDidTap()
    func countItems() -> Int
    func monthYearText() -> String
    func weekDays() -> [String?]
    func firstWeekDayOfMonth() -> Int
    func item(at index: Int) -> CalendarDay
    func viewDidLoad()
    func today() -> Int
    func updateCurrentMonth()
    
    var delegate: CalendarViewControllerProtocol? { get set }
}

class CalendarPresenter: CalendarPresenterProtocol {
    
    private var currentDate = Date()
    private let calendar = Calendar.current
    private var dateComponents = DateComponents()
    private let dateFormatter = DateFormatter()
    private var calendarDay: [CalendarDay] = []
    
    weak var delegate: CalendarViewControllerProtocol?

    func nextMonthDidTap() {
        currentDate = Date.nextMonth(after: currentDate)
        updateCurrentMonth()
    }
    
    func previousMonthDidTap() {
        currentDate = Date.previousMonth(before: currentDate)
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
        let shortWeekdays = dateFormatter.shortWeekdaySymbols
        return shortWeekdays ?? ["1", "2", "3", "4", "5", "6", "7"]
    }
    
    // номер первого дня недели в текущем месяце
    func firstWeekDayOfMonth() -> Int {
        dateComponents = DateComponents(year: currentDate.year, month: currentDate.numberOfCurrentMonth, day: 1)
        if let firstDayOfMonth = calendar.date(from: dateComponents) {
            let dayOfWeek = calendar.component(.weekday, from: firstDayOfMonth)
            return dayOfWeek
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
                isToday: false,
                isActive: DataBase.share.getReminders(date: date),
                date: date
            )
            calendarDay.append(day)
        }
    }
}
