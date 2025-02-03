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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage()
        dateLabel.textColor = .mainDigit
        dateLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        eventLabel.textColor = .mainDigit
        eventLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        eventsTableView.backgroundColor = .clear
    }
    
    func backgroundImage() {
        // Устанавливаем картинку из assets на фон
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
        return DataBase.share.fetchTitles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as? EventsTableViewCell else {
            fatalError("Не удалось извлечь кастомную ячейку")
        }
        cell.eventImage.image = EventType(rawValue: Int(DataBase.share.fetchType()[indexPath.row]))?.image
        cell.eventImage.setImageColor(color: .mainPurple)
        
        cell.titleLabel.text = DataBase.share.fetchTitles()[indexPath.row] // Текст из массива
        let selectedDate = DataBase.share.fetchDate()[indexPath.row]
        
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
        let selectedName = DataBase.share.fetchTitles()[indexPath.row]
        let selectedDiscription = DataBase.share.fetchBodyes()[indexPath.row]
        let selectedDate = DataBase.share.fetchDate()[indexPath.row]
        let selectTypeImage = DataBase.share.fetchType()[indexPath.row]
        
        // Преобразование TimeInterval в Date
        let date = Date(timeIntervalSince1970: selectedDate)
        
        // Форматируем дату для отображения
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        
        // получить reminders
        var reminders = [Reminder]()
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            let reminder = try DataBase.share.persistentContainer.viewContext.fetch(fetchRequest)
            print(reminder)
            reminders = reminder
        } catch {
            print("Failed to fetch reminder: \(error)")
        }
        
        // Инициализируем SecondViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let eventVC = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController {
            eventVC.hidesBottomBarWhenPushed = true  // убрать Таб Бар с экрана
            
            // Передаем данные во второй экран
            eventVC.name = selectedName
            eventVC.descriptionText = selectedDiscription
            eventVC.date = dateFormatter.string(from: date)
            eventVC.type = selectTypeImage
            eventVC.reminder = reminders[indexPath.row]
            
            // Переход на второй экран через push
            navigationController?.pushViewController(eventVC, animated: true)
        }
    }
    
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        62
    }
}
