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
            cellImageView.layer.borderWidth = 2.0
            cellImageView.layer.masksToBounds = true
        }
        
        // Включение отображения маски по границам
        cellImageView.clipsToBounds = true
    }
}
