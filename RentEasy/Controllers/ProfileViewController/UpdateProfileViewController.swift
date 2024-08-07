//
//  UpdateViewController.swift
//  RentEasy
//
//  Created by Apple on 6/8/24.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    private let profileUpdateView = ProfileUpdateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileUpdateView()
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        APICaller.getUserInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfo):
                    self?.profileUpdateView.updateProfile(with: userInfo)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: NetworkError) {
        // Handle error appropriately, e.g., show an alert
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    private func setupProfileUpdateView() {
        view.addSubview(profileUpdateView)
        
        profileUpdateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
