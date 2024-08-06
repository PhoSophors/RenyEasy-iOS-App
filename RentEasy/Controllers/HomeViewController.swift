//
//  HomeViewController.swift
//  RentEasy
//
//  Created by Apple on 4/8/24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
//        setupNavigationBar()
    }
    
//    private func setupNavigationBar() {
//        // Message button
//        let messageButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.message.fill"), style: .plain, target: self, action: #selector(messageButtonTapped))
//        messageButton.tintColor = .black
//        
//        // User button
//        let userButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(userButtonTapped))
//        userButton.tintColor = .black
//        
//        // Set left and right bar buttons
//        navigationItem.leftBarButtonItem = userButton
//        navigationItem.rightBarButtonItem = messageButton
//    }
//    
//    @objc private func messageButtonTapped() {
//        let messageVC = MainMessageViewController()
//        
//        // Set the modal presentation style
//        messageVC.modalPresentationStyle = .pageSheet
//        
//        // Present the view controller
//        present(messageVC, animated: true, completion: {
//            print("Message button tapped")
//        })
//    }
//
//    @objc private func userButtonTapped() {
//        // Handle user button tap
//        print("User button tapped")
//    }
}
