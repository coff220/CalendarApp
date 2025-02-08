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
    
    @IBOutlet private weak var weekDaysStackView: UIStackView!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var dateCollectionView: UICollectionView!
    @IBOutlet private weak var NoEventsImageView: UIImageView!
    @IBOutlet private weak var eventsTableView: UITableView!
    @IBOutlet private weak var eventsLabel: UILabel!
    
    @IBOutlet private weak var secondWeekDayLabel: UILabel!
    @IBOutlet private weak var firstWeekDayLabel: UILabel!
    @IBOutlet private weak var thirdWeekDayLabel: UILabel!
    @IBOutlet private weak var fourthWeekDayLabel: UILabel!
    @IBOutlet private weak var fifthWeekDayLabel: UILabel!
    @IBOutlet private weak var sixthWeekDayLabel: UILabel!
    @IBOutlet private weak var seventhWeekDayLabel: UILabel!
    
    var reminders = DataBase.share.fetchReminders()
    var presenter: CalendarPresenterProtocol = CalendarPresenter()

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
        configureSwipe()
        presenter.delegate = self
        presenter.viewDidLoad()
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        print(reminders.map{$0.title})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reminders = DataBase.share.fetchReminders()
        reloadData()
    }
    
    private func configure() {
        backgroundImage()
        eventsLabel.isHidden = true
        
        dateCollectionView.backgroundColor = .clear
        nextButton.backgroundColor = .clear
        previousButton.backgroundColor = .clear
        
        monthLabel.text = presenter.monthYearText()
        monthLabel.textColor = .mainDigit
        monthLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        
        eventsLabel.textColor = .mainDigit
        eventsLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
        eventsLabel.text = "Events"
        
        NoEventsImageView.image = UIImage(named: "NoEvents")

        dateCollectionView.isScrollEnabled = false

        for days in 0..<presenter.weekDays().count {
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
    
    private func configureSwipe() {
        // Добавляем жесты свайпа для collectionView
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        dateCollectionView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        dateCollectionView.addGestureRecognizer(swipeRight)
    }
    
    // Обработчик свайпов с анимацией
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let transitionOptions: UIView.AnimationOptions = .transitionCrossDissolve
        UIView.transition(with: dateCollectionView, duration: 0.5, options: transitionOptions, animations: {
            if gesture.direction == .left {
                self.presenter.nextMonthDidTap()
            } else if gesture.direction == .right {
                self.presenter.previousMonthDidTap()
            }
        }, completion: nil)
    }
    
    func backgroundImage() {
        if let backgroundImage = UIImage(named: "darkBG") {
            let backgroundImageView = UIImageView(frame: view.bounds)
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFill
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
    
    func showAddEvent() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigation = storyboard.instantiateViewController(identifier: "NoteViewController") as? UINavigationController,
        let vc = navigation.viewControllers.first as? NoteViewController else {
            return
        }
        
        vc.completion = {
            self.reminders = DataBase.share.fetchReminders()
            self.eventsTableView.reloadData()
            self.presenter.updateCurrentMonth()
        }
        present(navigation, animated: true, completion: nil)
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
    
    // MARK: - CalendarViewControllerProtocol
    
    func reloadData() {
        eventsTableView.reloadData()
        dateCollectionView.reloadData()
        monthLabel.text =  presenter.monthYearText()
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
        guard let navigation = storyboard.instantiateViewController(identifier: "NoteViewController") as? UINavigationController,
        let vc = navigation.viewControllers.first as? NoteViewController else {
            return
        }
        
        let devc = storyboard.instantiateViewController(withIdentifier: "DayEventsViewController") as? DayEventsViewController
            
        let eventVC = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController
        
        let selectedDate = presenter.item(at: indexPath.row)
        
        vc.update(date: selectedDate.date)
        vc.completion = {
            self.presenter.updateCurrentMonth()
        }
        
        if !selectedDate.isActive {
            vc.headLabelText = "Add Event"
            present(navigation, animated: true, completion: nil)
            
        } else if DataBase.share.fetchDayReminders(for: selectedDate.date).count > 1 {
            let remindersForSelectedDate = DataBase.share.fetchDayReminders(for: selectedDate.date)
            devc!.reminders = remindersForSelectedDate
            navigationController?.pushViewController(devc!, animated: true)
            
        } else {
            eventVC?.hidesBottomBarWhenPushed = true  // убрать Таб Бар с экрана
            let remindersForSelectedDate = DataBase.share.fetchDayReminders(for: selectedDate.date)
            eventVC!.reminder = remindersForSelectedDate[0]
            
            eventVC?.completion = {
                self.reminders = DataBase.share.fetchReminders()
                self.presenter.updateCurrentMonth()
                self.eventsTableView.reloadData()
            }
            
            // Переход на второй экран через push
            navigationController?.pushViewController(eventVC!, animated: true)
        }
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

// MARK: TableView
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !reminders.isEmpty {
            NoEventsImageView.isHidden = true
            eventsLabel.isHidden = false
        } else {
            NoEventsImageView.isHidden = false
        }
        tableView.separatorStyle = .none  // убрать сеператоры между ячейками
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as? EventsTableViewCell else {
            fatalError("Не удалось извлечь кастомную ячейку")
        }
        cell.eventImage.image = EventType(rawValue: Int(reminders[indexPath.row].type))?.image
        cell.eventImage.setImageColor(color: .mainPurple)
        
        cell.titleLabel.text = reminders[indexPath.row].title // Текст из массива
        let selectedDate = reminders[indexPath.row].date
        
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
            eventVC.reminder = reminders[indexPath.row]
            
            eventVC.completion = {
                self.reminders = DataBase.share.fetchReminders()
                self.presenter.updateCurrentMonth()
                self.eventsTableView.reloadData()
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
