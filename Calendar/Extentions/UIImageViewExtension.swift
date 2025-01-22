//
//  UIImageViewExtension.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 21/01/2025.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
