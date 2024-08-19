//
//  OTPViewController.swift
//  RentEasy
//
//  Created by Apple on 8/8/24.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var verifyOTPButton: UIButton!
    
    private var helper: Helper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.roundCorners([.topLeft, .topRight], radius: 30)
        
        verifyOTPButton.roundCorners([.allCorners], radius: 10)
        verifyOTPButton.backgroundColor = .systemIndigo
        
        // Initialize the helper
        helper = Helper(viewController: self)
        
        setupTextFields()
    }
    
    private func setupTextFields() {
        let textFields = [textField1, textField2, textField3, textField4, textField5, textField6]
        textFields.forEach {
            $0?.delegate = self
            $0?.keyboardType = .numberPad
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.count == 1 else { return }
        
        switch textField {
        case textField1:
            textField2.becomeFirstResponder()
        case textField2:
            textField3.becomeFirstResponder()
        case textField3:
            textField4.becomeFirstResponder()
        case textField4:
            textField5.becomeFirstResponder()
        case textField5:
            textField6.becomeFirstResponder()
        case textField6:
            textField6.resignFirstResponder()
        default:
            break
        }
    }
    
    @IBAction func verifyOTPButtonTapped(_ sender: UIButton) {
        let otp = [textField1, textField2, textField3, textField4, textField5, textField6].compactMap { $0?.text }.joined()
        
        guard !otp.isEmpty else {
            showAlert(title: "Error", message: "Please enter the OTP.")
            return
        }
        
        guard let email = UserDefaults.standard.string(forKey: "registeredEmail") else {
            showAlert(title: "Error", message: "Email not found.")
            return
        }
        
        APICaller.verifyRegisterOTP(email: email, otp: otp) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let token):
                        // Save the token to UserDefaults
                        AuthManager.saveToken(token)
                        print("OTP verification successful. Token saved.")
                        
                        self.navigateToMainViewController()
                    case .failure(let error):
                        ErrorHandlingUtility.handle(error: error, in: self)
                }
            }
        }
    }
    
    private func navigateToMainViewController() {
        let mainVC = MainViewController() // Instantiate your main view controller
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    static func present(from viewController: UIViewController) {
        let otpViewController = OTPViewController(nibName: "OTPViewController", bundle: nil)
        otpViewController.modalPresentationStyle = .fullScreen
        viewController.present(otpViewController, animated: true, completion: nil)
    }
}
