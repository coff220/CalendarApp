//
//  SettingsViewController.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 24/12/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var themeNameLabel: UILabel!
    @IBOutlet weak var dayFormatLabel: UILabel!
    @IBOutlet weak var firstWeekDayLabel: UILabel!
    @IBOutlet weak var timeStyleLabel: UILabel!
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var twentyFourHourLabel: UILabel!
    @IBOutlet weak var dateFormatLabel: UILabel!
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var notifyAtLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Установка фонового изображения
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "eventBG") // Ваше изображение
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0) // Добавляем на задний план
        config()
    }
    
    func config() {
        themeLabel.textColor = .mainDigit
        themeLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        twentyFourHourLabel.textColor = .mainDigit
        twentyFourHourLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        dateFormatLabel.textColor = .mainDigit
        dateFormatLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        firstDayLabel.textColor = .mainDigit
        firstDayLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        notifyAtLabel.textColor = .mainDigit
        notifyAtLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        notificationsLabel.textColor = .mainDigit
        notificationsLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        settingsLabel.textColor = .mainDigit
        settingsLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        
        themeNameLabel.textColor = .greySettingsVC
        dayFormatLabel.textColor = .greySettingsVC
        firstWeekDayLabel.textColor = .greySettingsVC
        timeStyleLabel.textColor = .mainPurple
    }
    // цвет текста для всех UILabel на экране
    //    private func updateLabelsTextColor(to color: UIColor) {
    //        for subview in view.subviews {
    //            if let label = subview as? UILabel {
    //                label.textColor = color
    //            }
    //        }
    //    }
}
