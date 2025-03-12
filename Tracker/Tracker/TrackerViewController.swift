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
    func didCreateTracker(_ tracker: Tracker, at category: TrackerCategory)
}

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenter? { get }
}

import UIKit

final class TrackerViewController: UIViewController, UISearchBarDelegate, TrackerTypeDelegate, HabitCreatingDelegate, TrackersViewControllerProtocol {
    
    // MARK: - Publike Properties
    
    var presenter: TrackersPresenter?
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
    
    private lazy var trackersCollectionView:  UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - HabitCreatingDelegate 
    
    func didCreateTracker(_ tracker: Tracker, at category: TrackerCategory) {
        presenter?.addTracker(tracker, at: category)
        print(tracker)
        print(category)
        trackersCollectionView.reloadData()
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
            emptyTrackerText.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // trackersCollectionView Constraints
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            trackersCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(trackersCollectionView)
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
        let habitCreatingPresenter = HabitCreatingPresenter(trackerType: type, categories: presenter?.categories ?? [])
        habitCreatingViewController.presenter = habitCreatingPresenter
        habitCreatingPresenter.view = habitCreatingViewController
        habitCreatingPresenter.delegate = self
        
        let navigatorController = UINavigationController(rootViewController: habitCreatingViewController)
        present(navigatorController, animated: true, completion: nil)
    }
    
    private func setupEmptyScreen() {
        emptyTrackerImage.isHidden = presenter?.categories.count ?? 0 > 0
        emptyTrackerText.isHidden = presenter?.categories.count ?? 0 > 0
        trackersCollectionView.isHidden = presenter?.categories.count == 0
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.categories[section].trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.cellIdentifier, for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        if let tracker = presenter?.categories[indexPath.section].trackers[indexPath.row] {
            cell.nameLabel.text = tracker.name
            cell.emojiLabel.text = tracker.emoji
            cell.cardView.backgroundColor = tracker.color
            cell.plusButton.backgroundColor = tracker.color
        }

        //cell.delegate = self

        return cell
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - Contstants.contentInsets * 2 - Contstants.spacing) / 2 , height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return Contstants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 16, right: 0)
    }
}

enum Contstants {
    static let cellIdentifier = "TrackerCell"
    static let contentInsets: CGFloat = 16
    static let spacing: CGFloat = 9
}
