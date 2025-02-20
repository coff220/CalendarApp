//
//  ViewController.swift
//  Calendar
//
//  Created by Viacheslav on 05/10/2024.
//

import UIKit
import CoreData
import FirebaseCrashlytics

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
  //  @IBOutlet weak var eventsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var eventsLabel: UILabel!
    
    @IBOutlet private weak var secondWeekDayLabel: UILabel!
    @IBOutlet private weak var firstWeekDayLabel: UILabel!
    @IBOutlet private weak var thirdWeekDayLabel: UILabel!
    @IBOutlet private weak var fourthWeekDayLabel: UILabel!
    @IBOutlet private weak var fifthWeekDayLabel: UILabel!
    @IBOutlet private weak var sixthWeekDayLabel: UILabel!
    @IBOutlet private weak var seventhWeekDayLabel: UILabel!
    
    @IBOutlet private weak var currentMonthButton: UIButton!
    
    var reminders = DataBase.share.fetchReminders()
    var presenter: CalendarPresenterProtocol = CalendarPresenter()

    @IBAction func todayButtonAction(_ sender: Any) {
        presenter.todayDidTap()
        currentMonthButton.isEnabled = presenter.isCurrentMonth()
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        presenter.previousMonthDidTap()
        currentMonthButton.isEnabled = presenter.isCurrentMonth()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        presenter.nextMonthDidTap()
        currentMonthButton.isEnabled = presenter.isCurrentMonth()
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
            // print(reminders.map{$0.title})
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("NoteSaved"), object: nil)
        currentMonthButton.isEnabled = presenter.isCurrentMonth()
        
        scheduleMidnightUpdate()
      //  swipeEventsTableView()
        
        // Логируем ошибку в Crashlytics
       
                Crashlytics.crashlytics().log("Открыли главный экран")
            //   fatalError("Тестовый краш Crashlytics")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reminders = DataBase.share.fetchReminders()
        reloadData()
    }
    
    @objc func update() {
            self.reminders = DataBase.share.fetchReminders()
            self.eventsTableView.reloadData()
        self.presenter.updateCurrentMonth()
        
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
    
    func scheduleMidnightUpdate() {
        let now = Date()
        let calendar = Calendar.current
        let midnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .strict)!

        let secondsUntilMidnight = midnight.timeIntervalSince(now)

        Timer.scheduledTimer(withTimeInterval: secondsUntilMidnight, repeats: false) { _ in
            self.presenter.updateCurrentMonth()
            self.eventsTableView.reloadData()
            self.scheduleMidnightUpdate() // Перезапускаем таймер на следующий день
        }
    }

//    private func swipeEventsTableView() {
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe2(_:)))
//            swipeUp.direction = .up
//        eventsTableView.addGestureRecognizer(swipeUp)
//
//            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe2(_:)))
//            swipeDown.direction = .down
//        eventsTableView.addGestureRecognizer(swipeDown)
//    }
//    
//    @objc func handleSwipe2(_ gesture: UISwipeGestureRecognizer) {
//        if gesture.direction == .up {
//            expandTableView()
//        } else if gesture.direction == .down {
//            collapseTableView()
//        }
//    }
//
//    func expandTableView() {
//        eventsTableViewHeightConstraint.constant = UIScreen.main.bounds.height
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func collapseTableView() {
//        let labelBottomY = eventsLabel.frame.maxY // Нижняя граница лейбла
//        let screenHeight = UIScreen.main.bounds.height
//        let collapsedHeight = screenHeight - labelBottomY - 16 // Учитываем отступ 16pt
//
//        eventsTableViewHeightConstraint.constant = collapsedHeight
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
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
            self.reminders = DataBase.share.fetchReminders()
            self.presenter.updateCurrentMonth()
            self.eventsTableView.reloadData()
        }
        
        if !selectedDate.isActive {
            vc.headLabelText = "Add Event"
            present(navigation, animated: true, completion: nil)
            
        } else if DataBase.share.fetchDayReminders(for: selectedDate.date).count > 1 {
            let remindersForSelectedDate = DataBase.share.fetchDayReminders(for: selectedDate.date)
            devc!.reminders = remindersForSelectedDate
            navigationController?.pushViewController(devc!, animated: true)
            
        } else {
            let remindersForSelectedDate = DataBase.share.fetchDayReminders(for: selectedDate.date)
            eventVC?.updateWith(reminder: remindersForSelectedDate[0], id: nil)
            eventVC?.completion = {
                self.reminders = DataBase.share.fetchReminders()
                self.presenter.updateCurrentMonth()
                self.eventsTableView.reloadData()
            }
            
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
 
        if !sortedReminders().isEmpty {
            NoEventsImageView.isHidden = true
            eventsLabel.isHidden = false
        } else {
            NoEventsImageView.isHidden = false
        }
        tableView.separatorStyle = .none  // убрать сеператоры между ячейками
        return sortedReminders().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as? EventsTableViewCell else {
            fatalError("Не удалось извлечь кастомную ячейку")
        }
        
        cell.eventImage.image = EventType(rawValue: Int(sortedReminders()[indexPath.row].type))?.image
        cell.eventImage.setImageColor(color: .mainPurple)
        
        cell.titleLabel.text = sortedReminders()[indexPath.row].title // Текст из массива
        let selectedDate = sortedReminders()[indexPath.row].date
        
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
        
        // Инициализируем SecondViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let eventVC = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController {
            eventVC.updateWith(reminder: sortedReminders()[indexPath.row], id: nil)
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
    
    func sortedReminders() -> [Reminder] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date()) // Получаем начало текущего дня
        let now = startOfDay.timeIntervalSince1970
        let filteredReminders = reminders.filter { $0.date >= now }
        let sortedReminders = filteredReminders.sorted { $0.date < $1.date }
        return sortedReminders
    }
}
