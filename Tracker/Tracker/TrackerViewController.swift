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

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didComplete(_ tracker: Tracker, date: Date)
}

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenter? { get }
    func didAddTracker()
    func didFilterTrackersByDate()
}

import UIKit

final class TrackerViewController: UIViewController, TrackerTypeDelegate, HabitCreatingDelegate, TrackersViewControllerProtocol, TrackerCollectionViewCellDelegate {
    
    // MARK: - Publike Properties
    
    var presenter: TrackersPresenter?
    
    // MARK: - Private Properties

    private lazy var datePicker: UIBarButtonItem = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = .tBlue

        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        let datePicker = UIBarButtonItem(customView: picker)
        return datePicker
    }()
    
    private lazy var emptyTrackerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyTrackerStar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = false
        return imageView
    }()
    
    private lazy var emptyTrackerText: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackersCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.cellIdentifier)
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.supplementaryIdentifier)
        
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

    func didAddTracker() {
        updateEmptyScreenVisibility()
    }

    func didFilterTrackersByDate() {
        trackersCollectionView.reloadData()
        updateEmptyScreenVisibility()
    }
    
    // MARK: - TrackerTypeDelegate
    
    func didSelectType(_ type: TrackerType) {
        showHabitCreatingScreen(type)
    }
    
    // MARK: - HabitCreatingDelegate
    
    func didCreateTracker(_ tracker: Tracker, at category: TrackerCategory) {
        presenter?.addTracker(tracker, at: category)
    }
    
    // MARK: - TrackerCollectionViewCellDelegate
    
    func didComplete(_ tracker: Tracker, date: Date) {
        presenter?.completeTracker(tracker, date: date)
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapAddButton(_ sender: Any) {
        showNewTrackerScreen()
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        presenter?.currentDate = sender.date
        presenter?.filterTrackersByDate(sender.date)
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
        
        if let data = presenter?.currentDate {
            presenter?.filterTrackersByDate(data)
        }
        
        updateEmptyScreenVisibility()
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
        let newTrackerTypeViewController = TrackerTypeViewController()
        let newTrackerTypePresenter = TrackerTypePresenter()
        newTrackerTypeViewController.presenter = newTrackerTypePresenter
        newTrackerTypePresenter.view = newTrackerTypeViewController
        newTrackerTypePresenter.delegate = self
        
        let navigatorController = UINavigationController(rootViewController: newTrackerTypeViewController)
        present(navigatorController, animated: true, completion: nil)
    }
    
    private func showHabitCreatingScreen(_ type: TrackerType) {
        let habitCreatingViewController = HabitViewController()
        let habitCreatingPresenter = HabitPresenter(trackerType: type, categories: presenter?.categories ?? [])
        habitCreatingViewController.presenter = habitCreatingPresenter
        habitCreatingPresenter.view = habitCreatingViewController
        habitCreatingPresenter.delegate = self
        
        let navigatorController = UINavigationController(rootViewController: habitCreatingViewController)
        present(navigatorController, animated: true, completion: nil)
    }
    
    private func updateEmptyScreenVisibility() {
        guard let categories = presenter?.filteredCategories else { return }
        let hasVisibleEmptyScreen = categories.isEmpty
        emptyTrackerImage.isHidden = hasVisibleEmptyScreen ? false: true
        emptyTrackerText.isHidden = hasVisibleEmptyScreen ? false: true
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter?.filteredCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.filteredCategories[section].trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.cellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            print("\(#file):\(#line)] \(#function) Ошибка приведения типа ячейки")
            return UICollectionViewCell()
        }
        
        if let presenter {
            let tracker = presenter.filteredCategories[indexPath.section].trackers[indexPath.row]
            let currentDate = presenter.currentDate
            let isCompleted = presenter.isTrackerCompleted(tracker, date: presenter.currentDate)
            let completedDaysCount = presenter.countCompletedDays(for:tracker)
            cell.delegate = self
            
            cell.configure(with: tracker, currentDate: currentDate, completedDaysCount: completedDaysCount, isCompleted: isCompleted)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerSupplementaryView.supplementaryIdentifier, for: indexPath) as? TrackerSupplementaryView else {
            print("\(#file):\(#line)] \(#function) Ошибка приведения типа header view")
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = presenter?.categories[indexPath.section].title
        return view
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInsets: CGFloat = 16
        let spacing: CGFloat = 9
        return CGSize(width: (collectionView.bounds.width - contentInsets * 2 - spacing) / 2 , height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spacing: CGFloat = 9
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 16, right: 0)
    }
}

extension TrackerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            let pinAction = UIAction(title: "Закрепить", image: UIImage(systemName: "pin")) { _ in
                print("Закрепить трекер")
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                print("Редактировать трекер")
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] _ in
                guard let self = self else { return }
                let alert = UIAlertController(
                    title: "Удалить трекер?",
                    message: "Эта операция не может быть отменена",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
                alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
                    print("deleteTracker")
                    // TODO deleteTracker(at: indexPath)
                })
                self.present(alert, animated: true)
            }
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}

extension TrackerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search = searchText
        trackersCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.search = ""
        trackersCollectionView.reloadData()
    }
}
