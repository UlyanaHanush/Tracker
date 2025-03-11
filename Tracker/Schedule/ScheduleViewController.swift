//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import UIKit

protocol ScheduleViewControllerProtocol {
    var presenter: SchedulePresenterProtocol? { get }
}

final class ScheduleViewController: UIViewController, ScheduleViewControllerProtocol {
    
    // MARK: - Publike Properties
    
    var presenter: SchedulePresenterProtocol?
    
    // MARK: - Private Properties
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle("Готово", for: .normal)
        button.tintColor = .white
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        button.titleLabel?.textAlignment = .center
        
        button.addTarget(nil, action: #selector(didReadyButton(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        
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
    
    // MARK: - IBAction
    
    @IBAction private func didReadyButton(_ sender: Any) {
        dismiss(animated: true)
        presenter?.done()
    }
    
    @IBAction private func didChangeSwitch(_ sender: UISwitch) {
        guard var presenter else { return }
        
        if sender.isOn {
            presenter.selectedWeekdays.append(sender.tag)
        } else if let index = presenter.selectedWeekdays.firstIndex(of: sender.tag) {
            presenter.selectedWeekdays.remove(at: index)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // readyButton Constraints
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,  constant: -16),
            
            // scheduleTableView Constraints
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scheduleTableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(readyButton)
        view.addSubview(scheduleTableView)
        
        setupConstraints()
        setupNavigationBar()
        view.backgroundColor = .white
    }
                        
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Расписание"
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    // действия при тапе на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func numberOfSections(in: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getWeekDays().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = presenter?.getWeekDays()[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        let weekdaySwitch = UISwitch()
        if let selected = presenter?.selectedWeekdays {
            weekdaySwitch.isOn = selected.contains(indexPath.row)
        }
        cell.accessoryView = weekdaySwitch
        weekdaySwitch.onTintColor = .tBlue
        weekdaySwitch.tag = indexPath.row
        weekdaySwitch.addTarget(self, action: #selector(didChangeSwitch), for: .touchUpInside)
        
        return cell
    }
}
