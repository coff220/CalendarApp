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
    func monthYearText () -> String
    func weekDays() -> [String?]
    func firstWeekDayOfMonth() -> Int 
    
    var delegate: CalendarViewControllerProtocol? { get set }
}

class CalendarPresenter: CalendarPresenterProtocol {
    
    private var currentDate = Date()
    private let calendar = Calendar.current
    private var dateComponents = DateComponents()
    private let dateFormatter = DateFormatter()
    
    weak var delegate: CalendarViewControllerProtocol?
    
    func nextMonthDidTap() {
        currentDate = Date.nextMonth(after: currentDate)
        delegate?.reloadData()
    }
    
    func previousMonthDidTap() {
        currentDate = Date.previousMonth(before: currentDate)
        delegate?.reloadData()
    }
    
    func countItems() -> Int {
        currentDate.daysInMonth
    }
    
    func monthYearText() -> String {
       " \(currentDate.month) \(currentDate.year) "
    }
    
    func weekDays() -> [String?] {
        let shortWeekdays = dateFormatter.shortWeekdaySymbols
        return shortWeekdays ?? ["1","2","3","4","5","6","7"]
    }
    
    func firstWeekDayOfMonth() -> Int {
        let numberWeekDay = currentDate.firstWeekDayOfMonth
        return numberWeekDay
    }
    
}

