//
//  SettingViewController.swift
//  RentEasy
//
//  Created by Apple on 6/8/24.
//

import UIKit

// Assume AuthManager is properly imported or defined
// import AuthManager

class SettingViewController: UIViewController {
    
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.title = "Setting"
        
        setupLogoutButton()
    }
    
    private func setupLogoutButton() {
        // Configure the logout button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.tintColor = .white
        logoutButton.layer.cornerRadius = 8
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // Add button to the view and set constraints
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        // Call the AuthManager's clearToken method
        AuthManager.clearToken()
       
        
        // Create and configure the login view controller
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        // Get the app's main window and set the new root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }

}
