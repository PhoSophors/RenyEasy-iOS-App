//
//  PrivacyConsentViewController.swift
//  RentEasy
//
//  Created by Apple on 22/8/24.
//

import Foundation
import UIKit

class PrivacyConsentViewController: UIViewController {
    
    private let consentLabel: UILabel = {
        let label = UILabel()
        label.text = "Please agree to our privacy terms before proceeding."
        label.numberOfLines = 0
        return label
    }()
    
    private let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Agree", for: .normal)
        button.addTarget(self, action: #selector(agreeTapped), for: .touchUpInside)
        return button
    }()
    
    var onAgree: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(consentLabel)
        view.addSubview(agreeButton)
        
        consentLabel.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            consentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            consentLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            consentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            consentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            agreeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            agreeButton.topAnchor.constraint(equalTo: consentLabel.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func agreeTapped() {
        onAgree?()
        dismiss(animated: true, completion: nil)
    }
}
