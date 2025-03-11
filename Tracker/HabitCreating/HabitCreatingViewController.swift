//
//  HabitCreatingViewController.swift
//  Tracker
//
//  Created by ulyana on 5.03.25.
//

import UIKit

protocol ScheduleDelegate {
    func didSelect(weekdays: [Int])
}

protocol HabitCreatingViewControllerProtocol {
    var presenter: HabitCreatingPresenterProtocol? { get }
}

final class HabitCreatingViewController: UIViewController, HabitCreatingViewControllerProtocol,  ScheduleDelegate {
    
    // MARK: - Publike Properties
    
    var presenter: HabitCreatingPresenterProtocol?
    
    // MARK: - Private Properties
    
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
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.rowHeight = 75
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
    }
    
    // MARK: - TimetableDelegate
       
    func didSelect(weekdays: [Int]) {
        presenter?.schedule = weekdays
//        updateButtonState()
//        tableView.reloadData()
    }
    
    // MARK: - IBAction
    
    @IBAction private func didCreateButton(_ sender: Any) {
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
            // buttonsStackView Constraints
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // tableview Constraints
            planningTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            planningTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            planningTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            planningTableView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(buttonsStackView)
        view.addSubview(planningTableView)
        
        setupConstraints()
        setupNavigationBar()
        view.backgroundColor = .white
    }
    
    private func rowsForSection(_ type: Section) -> [Section.Row] {
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
        
    }
}

// MARK: - UITableViewDelegate

extension HabitCreatingViewController: UITableViewDelegate {
    // действия при тапе на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch rowsForSection(section)[indexPath.row] {
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
extension HabitCreatingViewController: UITableViewDataSource {
    func numberOfSections(in: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        return rowsForSection(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch rowsForSection(section)[indexPath.row] {
            
        case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier) as? TextFieldCell else {
                return UITableViewCell()
            }
            return cell
            
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as? TableViewCell else { return UITableViewCell() }
            cell.textLabel?.text = "Категория"
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .schedule:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as? TableViewCell else { return UITableViewCell() }
            cell.textLabel?.text = "Расписание"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

