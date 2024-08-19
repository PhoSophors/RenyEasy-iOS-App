import UIKit

class SetNewPasswordViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveNewPasswordButton: UIButton!
    
    private var isPasswordVisible = false
    private var isConfirmPasswordVisible = false
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.roundCorners([.allCorners], radius: 10)
        confirmPasswordTextField.roundCorners([.allCorners], radius: 10)
        
        saveNewPasswordButton.roundCorners([.allCorners], radius: 10)
        saveNewPasswordButton.backgroundColor = .systemIndigo
        saveNewPasswordButton.tintColor = .white
        
        addEyeIconToPasswordTextField()
        addEyeIconToConfirmPasswordTextField()
    }
    
    @IBAction func saveNewPasswordButtonTapped(_ sender: UIButton) {
        guard let email = email,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        guard validate(password: password, confirmPassword: confirmPassword) else {
            return
        }

        APICaller.setNewPassword(email: email, newPassword: password, confirmPassword: confirmPassword) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("Password reset successful: \(message)")
                    self.handleSetNewPasswordSuccess()
                case .failure(let error):
                    ErrorHandlingUtility.handle(error: error, in: self)
                }
            }
        }
    }

    func handleSetNewPasswordSuccess() {
        print("New Password set successfully.")
        // Ensure that the XIB file name matches the one used here
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginVC.modalPresentationStyle = .fullScreen
        
        // Ensure that you have a navigationController
        if let navigationController = self.navigationController {
            navigationController.pushViewController(loginVC, animated: true)
        } else {
            // If there is no navigation controller, present modally
            self.present(loginVC, animated: true, completion: nil)
        }
    }


    func validate(password: String, confirmPassword: String) -> Bool {
        if password.count < 6 {
            showAlert(title: "Validation Error", message: "Password must be at least 6 characters long.")
            return false
        }
        if password != confirmPassword {
            showAlert(title: "Validation Error", message: "Passwords do not match.")
            return false
        }
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func addEyeIconToPasswordTextField() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.tintColor = .black
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightView.addSubview(eyeButton)
        
        passwordTextField.rightView = rightView
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
    }
    
    private func addEyeIconToConfirmPasswordTextField() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.tintColor = .black
        eyeButton.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightView.addSubview(eyeButton)
        
        confirmPasswordTextField.rightView = rightView
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        
        if let eyeButton = passwordTextField.rightView?.subviews.first as? UIButton {
            eyeButton.setImage(UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash"), for: .normal)
        }
    }
    
    @objc private func toggleConfirmPasswordVisibility() {
        isConfirmPasswordVisible.toggle()
        confirmPasswordTextField.isSecureTextEntry = !isConfirmPasswordVisible
        
        if let eyeButton = confirmPasswordTextField.rightView?.subviews.first as? UIButton {
            eyeButton.setImage(UIImage(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash"), for: .normal)
        }
    }
}
