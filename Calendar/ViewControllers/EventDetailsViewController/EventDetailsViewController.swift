//
//  EventDetailsViewController.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 21/12/2024.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var eventDetaleLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var completion: (() -> Void)?
    var reminder = Reminder()
    var id: String?
    var eventTitleFromPush: String = ""
    var eventBodyFromPush: String = ""
    var eventDateFromPush: TimeInterval = 0.0
    var eventTimeFromPush: Date = Date()
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Note?",
                                      message: "This action cannot be undone.",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DataBase.share.deleteContext(self.reminder)
            self.completion?()
            self.navigationController?.popViewController(animated: true) // Close screen
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        // переход на NoteViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let noteVC = storyboard.instantiateViewController(withIdentifier: "NoteViewController2") as? NoteViewController {
            noteVC.reminder = reminder
            noteVC.headLabelText = "Edit Event"
           // navigationController?.pushViewController(noteVC, animated: true)
            self.navigationController?.popViewController(animated: false)
            present(noteVC, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage()
        configure()
        
        // Преобразование TimeInterval в Date
        let date = Date(timeIntervalSince1970: reminder.date)
        
        // Форматируем дату для отображения
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy HH:mm"
        dateFormatter.locale = Locale.current
    
        discriptionLabel.text = reminder.body
        dateLabel.text = dateFormatter.string(from: date)
        nameLabel.text = reminder.title
        typeImageView.image = EventType(rawValue: Int(reminder.type))?.image
    }
    
    func configure() {
        editButton.layer.borderColor = UIColor.mainPurple.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 12
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        
        trashButton.layer.borderColor = CGColor(red: 255/255, green: 69/255, blue: 51/255, alpha: 1)
        trashButton.layer.borderWidth = 1
        trashButton.layer.cornerRadius = 12
        
        nameLabel.textColor = .mainDigit
        dateLabel.textColor = .mainDigit
        discriptionLabel.textColor = .mainDigit
        eventDetaleLabel.textColor = .mainDigit
        
        nameLabel.font = UIFont(name: "VarelaRound-Regular", size: 27)
        dateLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        discriptionLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        eventDetaleLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
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
