//
//  MyPageViewController.swift
//  Tracker
//
//  Created by ulyana on 27.05.26.
//

import UIKit

struct PageData {
    let title: String
    let image: UIImage
}

class MyPageViewController: UIViewController {
     
    // MARK: - Publike Properties
    
    var data: PageData? {
        didSet {
            updateView() // Обновляем UI при смене данных
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var pageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pageText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        
        button.addTarget(nil, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapButton(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "pageButtonTapped")
        showNewTabBarScreen()
    }
    
    // MARK: - Publik Methods
    
    func updateView() {
        guard let data = data else { return }
        pageImage.image = data.image
        pageText.text = data.title
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // pageButton Constraints
            pageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            pageButton.heightAnchor.constraint(equalToConstant: 60),
            
            // pageImage Constraints
            pageImage.topAnchor.constraint(equalTo: view.topAnchor),
            pageImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            // pageText Constraints
            pageText.bottomAnchor.constraint(equalTo: pageButton.topAnchor, constant: -160),
            pageText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            pageText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(pageImage)
        view.addSubview(pageButton)
        view.addSubview(pageText)
        
        setupConstraints()
    }
    
    private func showNewTabBarScreen() {
        let tabBarController = TabBarController()
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarController
        }
    }
}
