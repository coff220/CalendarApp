//
//  ViewController.swift
//  Calendar
//
//  Created by Viacheslav on 05/10/2024.
//

import UIKit
import CoreData

protocol CalendarViewControllerProtocol: AnyObject {
    func reloadData()
}

class CalendarViewController: UIViewController, CalendarViewControllerProtocol {
    
    @IBOutlet weak var weekDaysStackView: UIStackView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var NoEventsImageView: UIImageView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var eventsLabel: UILabel!
    
    @IBOutlet weak var secondWeekDayLabel: UILabel!
    @IBOutlet weak var firstWeekDayLabel: UILabel!
    @IBOutlet weak var thirdWeekDayLabel: UILabel!
    @IBOutlet weak var fourthWeekDayLabel: UILabel!
    @IBOutlet weak var fifthWeekDayLabel: UILabel!
    @IBOutlet weak var sixthWeekDayLabel: UILabel!
    @IBOutlet weak var seventhWeekDayLabel: UILabel!
    
    var presenter: CalendarPresenterProtocol = CalendarPresenter()
    
    func reloadData() {
        eventsTableView.reloadData()
        dateCollectionView.reloadData()
        monthLabel.text =  presenter.monthYearText()
        //  presenter.updateCurrentMonth()
    }
    
    @IBAction func todayButtonAction(_ sender: Any) {
        presenter.todayDidTap()
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        presenter.previousMonthDidTap()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        presenter.nextMonthDidTap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter.delegate = self
        presenter.viewDidLoad()
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func configure () {
        backgroundImage()
        eventsLabel.isHidden = true
        
        dateCollectionView.backgroundColor = .clear
        nextButton.backgroundColor = .clear
        previousButton.backgroundColor = .clear
        
        monthLabel.text = presenter.monthYearText()
        monthLabel.textColor = .mainDigit
        monthLabel.font = UIFont(name: "VarelaRound-Regular", size: 25)
        
        eventsLabel.textColor = .mainDigit
        eventsLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        eventsLabel.text = "Events"
        
        NoEventsImageView.image = UIImage(named: "NoEvents")
        
        for days in 0..<presenter.weekDays().count {
            print(presenter.weekDays())
            let label = weekDaysStackView.arrangedSubviews[days] as? UILabel
            label?.text = presenter.weekDays()[days]
            label?.font = UIFont(name: "VarelaRound-Regular", size: 17)
        }
        
        // Изменяем цвет текста всех UILabel внутри stackView
        for case let label as UILabel in weekDaysStackView.arrangedSubviews {
            label.textColor = .mainDigit
        }
        weekDaysStackViewSetup()
        
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
    
    func weekDaysStackViewSetup() {
        if presenter.isSundayFirstDayOfWeek() {
            firstWeekDayLabel.textColor = .mainPurple
            seventhWeekDayLabel.textColor = .mainPurple
        } else {
            sixthWeekDayLabel.textColor = .mainPurple
            seventhWeekDayLabel.textColor = .mainPurple
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.countItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        let currentDay = presenter.item(at: indexPath.row)
        cell.configureWith(day: currentDay)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
            return
        }
        
        let selectedDate = presenter.item(at: indexPath.row)
        vc.update(date: selectedDate.date)
        vc.completion = {
            self.presenter.updateCurrentMonth()
        }
        present(vc, animated: true, completion: nil)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 8, height: collectionView.frame.width / 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !DataBase.share.fetchTitles().isEmpty {
            NoEventsImageView.isHidden = true
            eventsLabel.isHidden = false
        } else {
            NoEventsImageView.isHidden = false
        }
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
            
            eventVC.completion = {
                self.presenter.updateCurrentMonth()
            }
            
            // Переход на второй экран через push
            navigationController?.pushViewController(eventVC, animated: true)
        }
    }
    
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        62
    }
}
