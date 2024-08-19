
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    private var isPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.roundCorners([.topLeft, .topRight], radius: 30)
        
        emailTextField.roundCorners([.allCorners], radius: 10)
        passwordTextField.roundCorners([.allCorners], radius: 10)
        
        loginBtn.roundCorners([.allCorners], radius: 10)
        loginBtn.backgroundColor = ColorManagerUtilize.shared.forestGreen
        
        // Add tap gesture recognizer to registerLabel
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToRegister))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tapGesture)
        
        let tabOnForgotPasswrod = UITapGestureRecognizer(target: self, action: #selector(navigaionToForgotPassword))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(tabOnForgotPasswrod)
        
        addEyeIconToPasswordTextField()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
    
        // Show loading
        LoadingOverlay.shared.show(over: self.view)

        if validate(email: email, password: password) {
            APICaller.login(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let token):
                            LoadingOverlay.shared.hide()
                            self.handleLoginSuccess(token: token)
                        case .failure(let error):
                            ErrorHandlingUtility.handle(error: error, in: self)
                    }
                }
            }
        } else {
            // hide loading if validation fails
            LoadingOverlay.shared.hide()
        }
    }

    func handleLoginSuccess(token: String) {
        print("Login successful, token: \(token)")
        
        // Save accessToken to User Defaults
        AuthManager.saveToken(token)
        
        // Create and configure the main view controller
        let mainVC = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        // Get the app's main window and set the new root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    // MARK: Login valication
    func validate(email: String, password: String) -> Bool {
        // Check if fields are empty
        if email.isEmpty || password.isEmpty {
            showAlert(title: "Validation Error", message: "Email and password fields cannot be empty.")
            return false
        }
        
        // Validate email format
        let emailRegEx = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPred = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            showAlert(title: "Validation Error", message: "Please enter a valid email address.")
            return false
        }
        
        // Password length check (example: at least 6 characters)
        if password.count < 6 {
            showAlert(title: "Validation Error", message: "Password must be at least 6 characters long.")
            return false
        }
        
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Navigation label to register screen
    @objc func navigateToRegister() {
        // Instantiate RegisterViewController from XIB
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        registerVC.modalPresentationStyle = .fullScreen // or .overFullScreen for a different effect
        self.present(registerVC, animated: true, completion: nil)
    }
    
    // MARK: Navigation label to forgot password screen
//    @objc func navigaionToForgotPassword() {
//        let forgotPasswordVC = ForgotPasswordViewController()
////        forgotPasswordVC.modalPresentationStyle = .fullScreen
//        self.present(forgotPasswordVC, animated: true, completion: nil)
//        
//        print("Forgot password label tapped..!")
//    }

    @objc func navigaionToForgotPassword() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let forgotPasswordVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
//            forgotPasswordVC.modalPresentationStyle = .fullScreen
            self.present(forgotPasswordVC, animated: true, completion: nil)
            
            print("Forgot password label tapped..!")
        } else {
            print("ForgotPasswordViewController not found in storyboard")
        }
    }
    
    // MARK: Hidden text for password
    private func addEyeIconToPasswordTextField() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .selected)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightView.addSubview(eyeButton)
        
        passwordTextField.rightView = rightView
        passwordTextField.rightViewMode = .always
        
        passwordTextField.isSecureTextEntry = true
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        
        if let eyeButton = passwordTextField.rightView?.subviews.first as? UIButton {
            eyeButton.isSelected = isPasswordVisible
            eyeButton.setImage(UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash"), for: .normal)
        }
    }
    
}
