//
//  DayEventsViewController.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 03/02/2025.
//

import UIKit
import CoreData

class DayEventsViewController: UIViewController {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var reminders = DataBase.share.fetchReminders()
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage()
        dateLabelSetup()
        eventLabel.textColor = .mainDigit
        eventLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        eventsTableView.backgroundColor = .clear
    }
    
    func dateLabelSetup() {
        dateLabel.textColor = .mainDigit
        dateLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        let date = Date(timeIntervalSince1970: reminders[0].date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale.current
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    func backgroundImage() {
        if let backgroundImage = UIImage(named: "darkBG") {
            let backgroundImageView = UIImageView(frame: view.bounds)
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFill // Опционально: чтобы изображение заполнило весь экран
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Добавляем изображение как subview
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView) // Отправляем изображение на задний план
            
            // Устанавливаем ограничения для масштабирования фона на весь экран
            NSLayoutConstraint.activate([
                backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }

}

extension DayEventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = .none  // убрать сеператоры между ячейками
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as? EventsTableViewCell else {
            fatalError("Не удалось извлечь кастомную ячейку")
        }
        let reminder = reminders[indexPath.row]
        let type = Int(reminder.type)
        
        cell.eventImage.image = EventType(rawValue: type)?.image
        cell.eventImage.setImageColor(color: .mainPurple)
        
        cell.titleLabel.text = reminder.title // Текст из массива
        let selectedDate = reminder.date
        
        // Преобразование TimeInterval в Date
        let date = Date(timeIntervalSince1970: selectedDate)
        
        // Форматируем дату для отображения
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]
     
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let eventVC = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController {
            eventVC.hidesBottomBarWhenPushed = true
//            eventVC.reminder = reminder
            eventVC.updateWith(reminder: reminder, id: nil)
            navigationController?.pushViewController(eventVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        62
    }
}
