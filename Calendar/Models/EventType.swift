//
//  EventType.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 18/01/2025.
//

import Foundation
import UIKit

enum EventType: Int {
    case cake = 0
    case star = 1
    case heart = 2
    case danger = 3
    
    var image: UIImage? {
        switch self {
            
        case .cake:
            UIImage(named: "cake")
        case .star:
            UIImage(named: "star")
        case .heart:
            UIImage(named: "heart")
        case .danger:
            UIImage(named: "danger")
        }
    }
}
