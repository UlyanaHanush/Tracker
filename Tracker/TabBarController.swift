//
//  TabBarController.swift
//  Tracker
//
//  Created by ulyana on 25.02.25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .tBlue
    }
    
    // MARK: - Private Methods
    
    private func setupTabBar() {
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "record.circle.fill"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "hare.fill"), selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticsViewController]
    }
}
