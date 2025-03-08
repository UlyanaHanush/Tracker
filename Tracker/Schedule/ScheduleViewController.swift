//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Расписание"
    }
}
