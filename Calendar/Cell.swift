//
//  Cell.swift
//  Calendar
//
//  Created by Viacheslav on 07/10/2024.
//

import UIKit

 class Cell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
     
     func configureWith(day: CalendarDay) {
         
         layer.borderColor = UIColor.clear.cgColor
         
         layer.cornerRadius = 4
         dayLabel.text = day.title
         if day.isActive {
             layer.borderColor = UIColor.mainPurple.cgColor
                 layer.borderWidth = 2.0
                 layer.masksToBounds = true
         }
     }
}
