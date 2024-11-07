//
//  ViewController.swift
//  Calendar
//
//  Created by Viacheslav on 05/10/2024.
//

import UIKit

protocol CalendarViewControllerProtocol: AnyObject {
    func reloadData()
}

class CalendarViewController: UIViewController, CalendarViewControllerProtocol {
    
    @IBOutlet weak var weekDaysStackView: UIStackView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    var presenter: CalendarPresenterProtocol = CalendarPresenter()
    
    func reloadData() {
        dateCollectionView.reloadData()
        monthLabel.text =  presenter.monthYearText()
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
    }
    
    func configure () {
        backgroundImage()
        dateCollectionView.backgroundColor = .clear
        nextButton.layer.cornerRadius = nextButton.bounds.width / 2
        nextButton.backgroundColor = .lightGray
        nextButton.setTitle(">", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 70)
        
        previousButton.layer.cornerRadius = nextButton.bounds.width / 2
        previousButton.backgroundColor = .lightGray
        previousButton.setTitle("<", for: .normal)
        previousButton.titleLabel?.font = UIFont.systemFont(ofSize: 70) 
        
        monthLabel.text = presenter.monthYearText()
        
        for iii in 0..<presenter.weekDays().count {
         let label = weekDaysStackView.arrangedSubviews[iii] as? UILabel
            label?.text = presenter.weekDays()[iii]
        }
    }
    
    func backgroundImage() {
        // Устанавливаем картинку из assets на фон
        if let backgroundImage = UIImage(named: "blackWhite") {
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

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.countItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        let currentDay = presenter.item(at: indexPath.row)
        cell.layer.cornerRadius = 15
        cell.dayLabel.text = currentDay.title
        
//        if currentDay.isToday {
//            cell.backgroundColor = .systemPink
//        }
        if indexPath.row - presenter.firstWeekDayOfMonth() + 1 == presenter.today() - 1 {
            cell.backgroundColor = .systemPink
        } else {
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
           return 
        }
        present(vc, animated: true, completion: nil)
        vc.dateLabel?.text = "\(presenter.item(at: indexPath.row).title) \(presenter.monthYearText())"
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 8, height: collectionView.frame.width / 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
