//
//  Cell.swift
//  Calendar
//
//  Created by Viacheslav on 07/10/2024.
//

import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
  
    @IBOutlet weak var cellImageView: UIImageView!
    
    func configureWith(day: CalendarDay) {
        cellImageView.layer.borderColor = UIColor.clear.cgColor
        cellImageView.layer.cornerRadius = 4
        
        dayLabel.text = day.title
        if day.isActive {
            cellImageView.layer.borderColor = UIColor.mainPurple.cgColor
            cellImageView.layer.borderWidth = 1.0
            cellImageView.layer.masksToBounds = true
        }
    
        dayLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        dayLabel.textColor = .mainDigit
        if day.date.isWeekend() {
            if !day.isToday {
                dayLabel.textColor = .mainPurple
            } else {
                dayLabel.textColor = .mainDigit
            }
        }
        
        cellImageView.backgroundColor = .clear
        if day.isToday {
            cellImageView.backgroundColor = .mainPurple
        }
        
        // Включение отображения маски по границам
        cellImageView.clipsToBounds = true
    }
}
