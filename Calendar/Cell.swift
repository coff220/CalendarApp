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
         layer.cornerRadius = 15
         dayLabel.text = day.title
     }
}
