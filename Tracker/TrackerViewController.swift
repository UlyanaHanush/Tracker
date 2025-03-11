//
//  TrackerViewController.swift
//  Tracker
//
//  Created by ulyana on 25.02.25.
//

protocol TrackerTypeDelegate {
    func didSelectType(_ type: TrackerType)
}

protocol HabitCreatingDelegate {
    func didSelectSchedule()
}

import UIKit

final class TrackerViewController: UIViewController, UISearchBarDelegate, TrackerTypeDelegate, HabitCreatingDelegate {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Private Properties
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }()
    
    private lazy var datePicker: UIBarButtonItem = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .tBlue
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        let datePicker = UIBarButtonItem(customView: picker)
        return datePicker
    }()
    
    private lazy var emptyTrackerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyTrackerStar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyTrackerText: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView:  UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addSubviews()
    }
    
    // MARK: - Publike Methods
    
    func didSelectType(_ type: TrackerType) {
        showHabitCreatingScreen(type)
    }
    
    func didSelectSchedule() {
        showScheduleScreen()
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapAddButton(_ sender: Any) {
        showNewTrackerScreen()
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // emptyTrackerImage Constraints
            emptyTrackerImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyTrackerImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // emptyTrackerText Constraints
            emptyTrackerText.topAnchor.constraint(equalTo: emptyTrackerImage.bottomAnchor, constant: 8),
            emptyTrackerText.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(emptyTrackerImage)
        view.addSubview(emptyTrackerText)
        view.backgroundColor = .white

        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.setRightBarButton(datePicker, animated: true)
        
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
                
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        navigationBar.topItem?.searchController = searchController
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        leftButton.tintColor = .black
        navigationBar.topItem?.setLeftBarButton(leftButton, animated: true)
    }
    
    private func showNewTrackerScreen() {
        let newTrackerTypeViewController = NewTrackerTypeViewController()
        let newTrackerTypePresenter = NewTrackerTypePresenter()
        newTrackerTypeViewController.presenter = newTrackerTypePresenter
        newTrackerTypePresenter.view = newTrackerTypeViewController
        newTrackerTypePresenter.delegate = self
        
        let navigatorController = UINavigationController(rootViewController: newTrackerTypeViewController)
        present(navigatorController, animated: true, completion: nil)
    }
    
    private func showHabitCreatingScreen(_ type: TrackerType) {
        let habitCreatingViewController = HabitCreatingViewController()
        let habitCreatingPresenter = HabitCreatingPresenter(trackerType: type)
        habitCreatingViewController.presenter = habitCreatingPresenter
        habitCreatingPresenter.view = habitCreatingViewController
        habitCreatingPresenter.delegate = self
        
        let navigatorController = UINavigationController(rootViewController: habitCreatingViewController)
        present(navigatorController, animated: true, completion: nil)
    }
    
    private func showScheduleScreen() {
        let scheduleViewController = ScheduleViewController()
        let schedulePresenter = SchedulePresenter()
        schedulePresenter.view = scheduleViewController
        scheduleViewController.presenter = schedulePresenter
        
        let navigatorController = UINavigationController(rootViewController: scheduleViewController)
        present(navigatorController, animated: true, completion: nil)
    }
}
