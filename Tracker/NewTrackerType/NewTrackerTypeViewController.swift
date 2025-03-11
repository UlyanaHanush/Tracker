//
//  NewTrackerTypeViewController.swift
//  Tracker
//
//  Created by ulyana on 5.03.25.
//

import UIKit

protocol TrackerTypeViewControllerProtocol {
    var presenter: NewTrackerTypePresenterProtocol? { get }
}

final class NewTrackerTypeViewController: UIViewController, TrackerTypeViewControllerProtocol {
    
    // MARK: - Publike Properties
    
    var presenter: NewTrackerTypePresenterProtocol?
    
    // MARK: - Private Properties
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle("Привычка", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(nil, action: #selector(didHabitButton(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var irregularEventsButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle("Нерегулярные события", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(nil, action: #selector(didIrregularEventsButton(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
    }
    
    // MARK: - IBAction
    
    @IBAction private func didHabitButton(_ sender: Any) {
        dismiss(animated: true) {
            self.presenter?.selectType(.Habit)
        }
    }
    
    @IBAction private func didIrregularEventsButton(_ sender: Any) {
        dismiss(animated: true) {
            self.presenter?.selectType(.UnRegularEvent)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // habitButton Constraints
            habitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            habitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            // irregularEventsButton Constraints
            irregularEventsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            irregularEventsButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            irregularEventsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(habitButton)
        view.addSubview(irregularEventsButton)
        
        setupConstraints()
        setupNavigationBar()
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Создание трекера"
    }
}
