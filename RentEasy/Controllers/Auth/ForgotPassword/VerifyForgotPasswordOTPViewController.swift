//
//  VerifyForgotPasswordOTPViewController.swift
//  RentEasy
//
//  Created by Apple on 9/8/24.
//

import UIKit

class VerifyForgotPasswordOTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    
    var email: String?
    private var helper: Helper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verifyButton.roundCorners([.allCorners], radius: 10)
        verifyButton.backgroundColor = .systemIndigo
        verifyButton.tintColor = .white
        
        helper = Helper(viewController: self)
        
        setupTextFields()
    }
    
    // MARK: - Navigation
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
    
    // MARK: - Verify OTP Button Tapped
    @IBAction func VerifyForgotPasswordOTPTapped(_ sender: UIButton) {
        let otp = [textField1, textField2, textField3, textField4, textField5, textField6].compactMap { $0?.text }.joined()
        
        guard !otp.isEmpty else {
            showAlert(title: "Error", message: "Please enter the OTP.")
            return
        }
        
        guard let email = email else {
            showAlert(title: "Error", message: "Email not found.")
            return
        }
        
        LoadingOverlay.shared.show(over: self.view)
        
        APICaller.verifyResetPasswordOTP(email: email, otp: otp) { result in
            DispatchQueue.main.async {
                
                LoadingOverlay.shared.hide()
                
                switch result {
                case .success(_):
                    self.navigateToSetNewPasswordViewController()
                case .failure(let error):
                    ErrorHandlingUtility.handle(error: error, in: self)
                }
            }
        }
    }
    
    private func navigateToSetNewPasswordViewController() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let setNewPasswordViewController = storyboard.instantiateViewController(withIdentifier: "SetNewPasswordViewController") as? SetNewPasswordViewController {
            setNewPasswordViewController.email = email
            self.present(setNewPasswordViewController, animated: true, completion: nil)
        } else {
            print("SetNewPasswordViewController not found in storyboard")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
