//
//  SettingsViewController.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 24/12/2024.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var dayFormatLabel: UILabel!
    @IBOutlet weak var firstWeekDayLabel: UILabel!
    @IBOutlet weak var timeStyleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        // Установка фонового изображения
                let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                backgroundImage.image = UIImage(named: "eventBG") // Ваше изображение
                backgroundImage.contentMode = .scaleAspectFill
                view.insertSubview(backgroundImage, at: 0) // Добавляем на задний план
        
        // Устанавливаем цвет текста для всех UILabel на экране
            updateLabelsTextColor(to: UIColor.mainDigit)
            // timeStyleLabel.textColor = .mainDigit
        
    }
    
    private func updateLabelsTextColor(to color: UIColor) { // цвет текста для всех UILabel на экране
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = color
            }
        }
    }
}
