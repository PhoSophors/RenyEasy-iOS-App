//
//  ForgotPasswordViewController.swift
//  RentEasy
//
//  Created by Apple on 8/8/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forgot password screen"
        
        view.backgroundColor = .white
        
        // Set rounded corners for the email text field
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.borderStyle = .none

        // Set padding for the email text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .always
        
        resetButton.roundCorners([.allCorners], radius: 10)
        
        resetButton.backgroundColor = ColorManagerUtilize.shared.forestGreen
        resetButton.tintColor = .white
        
    }
    
    // MARK: - Navigation

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            return
        }
        
        LoadingOverlay.shared.show(over: self.view)
        
        if validate(email: email) {
            APICaller.requestNewPassword(email: email) { (result: Result<String, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        // Handle the success case with the received message
                        self.handleRequestNewPasswordSuccess()
                        // Optionally, you can use the message if needed
                        print("Success message: \(message)")
                    case .failure(let error):
                        ErrorHandlingUtility.handle(error: error, in: self)
                    }
                }
            }
        } else {
            LoadingOverlay.shared.hide()
        }
    }
    
    func handleRequestNewPasswordSuccess() {
        print("Forgot password successful.")
        
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let otpViewController = storyboard.instantiateViewController(withIdentifier: "VerifyForgotPasswordOTPViewController") as? VerifyForgotPasswordOTPViewController {
            otpViewController.email = emailTextField.text // Pass the email
            self.present(otpViewController, animated: true, completion: nil)
        } else {
            print("VerifyForgotPasswordOTPViewController not found in storyboard")
        }
    }
    
    // MARK: Forgot password valication
    func validate(email: String) -> Bool {
        // Check if fields are empty
        if email.isEmpty {
            showAlert(title: "Validation Error", message: "Email fields cannot be empty.")
            return false
        }
        
        // Validate email format
        let emailRegEx = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPred = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            showAlert(title: "Validation Error", message: "Please enter a valid email address.")
            return false
        }
        
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    

}
