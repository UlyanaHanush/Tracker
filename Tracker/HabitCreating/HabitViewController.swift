//
//  HabitCreatingViewController.swift
//  Tracker
//
//  Created by ulyana on 5.03.25.
//

import UIKit

protocol ScheduleDelegate {
    func didSelect(weekdays: [WeekDay])
}

protocol HabitViewControllerProtocol: AnyObject {
    var presenter: HabitPresenterProtocol? { get }
}

final class HabitViewController: UIViewController, HabitViewControllerProtocol,  ScheduleDelegate, TextFieldCellDelegate {
    
    // MARK: - Publike Properties
    
    var presenter: HabitPresenterProtocol?
    
    // MARK: - Private Properties
    
    private var selectedIndexEmoji: [Int?] = []
    private var selectedIndexColor: [Int?] = []
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .tGray
        button.setTitle("Создать", for: .normal)
        
        button.addTarget(nil, action: #selector(didCreateButton(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.cancelButton, for: .normal)
        button.layer.borderColor = UIColor.cancelButton.cgColor
        
        button.addTarget(nil, action: #selector(didCancelButton(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.distribution = .fillEqually
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    }()
    
    private lazy var planningTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emojiCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical
        //layout.itemSize = CGSize(width: 48, height: 48)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.cellIdentifier)
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.supplementaryIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.tag = 1
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var colorCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical
        //layout.itemSize = CGSize(width: 48, height: 48)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.cellIdentifier)
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.supplementaryIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.tag = 2
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
    }
    
    // MARK: - ScheduleDelegate
    
    func didSelect(weekdays: [WeekDay]) {
        presenter?.schedule = weekdays
        updateButtonState()
        planningTableView.reloadData()
    }
    
    // MARK: - TextFieldCellDelegate
    
    func didTextChange(text: String?) {
        presenter?.trackerName = text
        updateButtonState()
    }
    
    // MARK: - IBAction
    
    @IBAction private func didCreateButton(_ sender: Any) {
        presenter?.createNewTracker()
        dismiss(animated: true)
    }
    
    @IBAction private func didCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Новая привычка"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // scrollView Constraints
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            
            // buttonsStackView Constraints
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // tableview Constraints
            planningTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            planningTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            planningTableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            planningTableView.heightAnchor.constraint(equalToConstant: 290),
            
            // emojiCollectionView Constraints
            emojiCollectionView.topAnchor.constraint(equalTo: planningTableView.bottomAnchor),
            emojiCollectionView.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 210),
            
            // colorCollectionView Constraints
            colorCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 210),
        ])
    }
    
    private func addSubviews() {
        self.hideKeyboardOnTap()
        view.addSubview(scrollView)
        view.addSubview(buttonsStackView)
        scrollView.addSubview(planningTableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        
        setupConstraints()
        setupNavigationBar()
        view.backgroundColor = .white
    }
    
    private func rowsForTableSection(_ type: SectionHabitTableView) -> [SectionHabitTableView.Row] {
        switch type {
        case .textField:
            return [.textField]
        case .planning:
            switch presenter?.trackerType {
            case .Habit:
                return [.category, .schedule]
            case .UnRegularEvent:
                return [.category]
            case .none:
                return []
            }
        }
    }
    
    private func showScheduleScreen() {
        let scheduleViewController = ScheduleViewController()
        let schedulePresenter = SchedulePresenter(view: scheduleViewController, selectedWeekdays: presenter?.schedule ?? [], delegate: self)
        scheduleViewController.presenter = schedulePresenter
        
        let navigatorController = UINavigationController(rootViewController: scheduleViewController)
        present(navigatorController, animated: true, completion: nil)
    }
    
    private func showCategoryScreen() {
        // TODO
    }
    
    private func updateButtonState() {
        createButton.isEnabled = presenter?.isValidForm() ?? false
        createButton.backgroundColor = createButton.isEnabled ? .black : .tGray
    }
}

// MARK: - UITableViewDelegate

extension HabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SectionHabitTableView(rawValue: indexPath.section) else { return }
        switch rowsForTableSection(section)[indexPath.row] {
        case .category:
            showCategoryScreen()
        case .schedule:
            showScheduleScreen()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension HabitViewController: UITableViewDataSource {
    func numberOfSections(in: UITableView) -> Int {
        return SectionHabitTableView.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SectionHabitTableView(rawValue: section) else { return 0 }
        return rowsForTableSection(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionHabitTableView(rawValue: indexPath.section) else { return UITableViewCell() }
        switch rowsForTableSection(section)[indexPath.row] {
            
        case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier) as? TextFieldCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as? TableViewCell else { return UITableViewCell() }
            cell.textLabel?.text = "Категория"
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .schedule:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as? TableViewCell else { return UITableViewCell() }
            cell.textLabel?.text = "Расписание"
            cell.detailTextLabel?.text = presenter?.getShortFormWeekDays()
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

// MARK: - UIViewController 

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

extension HabitViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 1 {
            return presenter?.emojiCollectionView.count ?? 0
        } else if collectionView.tag == 2 {
            return presenter?.colorCollectionView.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return presenter?.emojiCollectionView[section].row.count ?? 0
        } else if collectionView.tag == 2 {
            return presenter?.colorCollectionView[section].row.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.cellIdentifier, for: indexPath) as? HabitCollectionViewCell else {
            print("\(#file):\(#line)] \(#function) Ошибка приведения типа ячейки")
            return UICollectionViewCell()
        }
        
        if collectionView.tag == 1 {
            guard let section = presenter?.emojiCollectionView[indexPath.section] else { return UICollectionViewCell() }
            cell.titleLabel.text = section.row[indexPath.row] as? String
            cell.layer.cornerRadius = 16
            return cell
        } else if collectionView.tag == 2 {
            guard let section = presenter?.colorCollectionView[indexPath.section] else { return UICollectionViewCell() }
            cell.viewCell.backgroundColor = section.row[indexPath.row] as? UIColor
            cell.viewCell.layer.cornerRadius = 8
            cell.layer.cornerRadius = 8
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerSupplementaryView.supplementaryIdentifier, for: indexPath) as? TrackerSupplementaryView else {
            print("\(#file):\(#line)] \(#function) Ошибка приведения типа header view")
            return UICollectionReusableView()
        }
        if collectionView.tag == 1 {
            view.titleLabel.text = presenter?.emojiCollectionView[indexPath.section].title
            return view
        } else if collectionView.tag == 2 {
            view.titleLabel.text = presenter?.colorCollectionView[indexPath.section].title
            return view
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
}

// MARK: - UICollectionViewDelegate

extension HabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? HabitCollectionViewCell
        if collectionView.tag == 1 {
            if let selectedEmoji = presenter?.emojiCollectionView[indexPath.section].row[indexPath.row] as? String {
                presenter?.selectedEmoji = selectedEmoji
                cell?.backgroundColor = .bgCell
            }
        } else if collectionView.tag == 2 {
            if let selectedColor = presenter?.colorCollectionView[indexPath.section].row[indexPath.row] as? UIColor {
                presenter?.selectedColor = selectedColor
                cell?.layer.masksToBounds = true
                cell?.layer.borderWidth = 3
                cell?.layer.borderColor = selectedColor.withAlphaComponent(0.3).cgColor
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as? HabitCollectionViewCell
            cell?.backgroundColor = .clear
        } else if collectionView.tag == 2 {
            let cell = collectionView.cellForItem(at: indexPath) as? HabitCollectionViewCell
            cell?.layer.masksToBounds = true
            cell?.layer.borderWidth = 0
            cell?.layer.borderColor = .none
        }
    }
}
