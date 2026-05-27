//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by ulyana on 27.05.26.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Constants
    
    private let pageDataArray = [
        PageData(title: "Отслеживайте только то, что хотите", image: UIImage(named: "backgroundOnbording1")!),
        PageData(title: "Даже если это не литры воды или йогa", image: UIImage(named: "backgroundOnbording2")!)
    ]
    
    // MARK: - Private Properties
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pageDataArray.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstPage = pageViewController(at:0) {
            setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        }
        
        addSubviews()
    }
    
    private func pageViewController(at index: Int) -> MyPageViewController? {
        guard index >= 0 && index < pageDataArray.count else {
             return nil
         }
        let controller = MyPageViewController()
        controller.data = pageDataArray[index]
        return controller
    }
    
    // Вспомогательный метод, чтобы понять, какой индекс у текущего экрана при перелистывании
    private func indexOf(viewController: UIViewController) -> Int? {
        guard let pageVC = viewController as? MyPageViewController,
              let data = pageVC.data else { return nil }
        
        // Ищем индекс объекта данных в общем массиве
        return pageDataArray.firstIndex { $0.title == data.title }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(pageControl)
        setupConstraints()
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // Проверяем, что анимация перелистывания успешно завершилась
        guard completed else { return }
        
        // Получаем текущий видимый экран
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = indexOf(viewController: currentViewController) {
            // Обновляем точку в UIPageControl
            pageControl.currentPage = currentIndex
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = indexOf(viewController: viewController) else { return nil }

        let previousIndex = currentIndex - 1
        
        if previousIndex < 0 {
            return self.pageViewController(at: pageDataArray.count - 1)
        }

        return self.pageViewController(at: previousIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = indexOf(viewController: viewController) else { return nil }
    
        let nextIndex = currentIndex + 1
        
        if nextIndex >= pageDataArray.count {
            return self.pageViewController(at: 0)
        }
        
        return self.pageViewController(at: nextIndex)
    }
}
