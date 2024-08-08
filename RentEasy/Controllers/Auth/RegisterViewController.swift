import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    private var helper: Helper?
    private var isPasswordVisible = false
    private var isConfirmPasswordVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.roundCorners([.allCorners], radius: 10)
        emailTextField.roundCorners([.allCorners], radius: 10)
        passwordTextField.roundCorners([.allCorners], radius: 10)
        confirmPasswordTextField.roundCorners([.allCorners], radius: 10)
        
        setupUI()
        
        // Initialize the helper
        helper = Helper(viewController: self)
        
        addEyeIconToPasswordTextField()
        addEyeIconToConfirmPasswordTextField()
    }
    
    private func setupUI() {
        backgroundView.roundCorners([.topLeft, .topRight], radius: 30)
        
        [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0?.roundCorners([.allCorners], radius: 10)
        }
        
        registerBtn.roundCorners([.allCorners], radius: 10)
        registerBtn.backgroundColor = .systemIndigo
        
        // Add tap gesture recognizer to loginLabel
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToLogin))
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            showAlert(title: "Error", message: "Please fill all fields.")
            return
        }
        
        if validate(username: username, email: email, password: password, confirmPassword: confirmPassword) {
            APICaller.register(username: username, email: email, password: password, confirmPassword: confirmPassword) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self.handleRegisterSuccess()
                    case .failure(let error):
                        let errorMessage: String
                        switch error {
                        case .urlError:
                            errorMessage = "URL Error"
                        case .canNotParseData:
                            errorMessage = "Failed to parse data"
                        case .serverError(let message):
                            errorMessage = message
                        case .invalidCredentials(let message):
                            errorMessage = message
                        case .unauthorized:
                            errorMessage = "Unauthorized access. Please check your credentials and try again."
                        case .forbidden:
                            errorMessage = "Access forbidden. You don't have permission to access this resource."
                        case .notFound:
                            errorMessage = "Resource not found. Please check the URL or try again later."
                        }
                        self.showAlert(title: "Error", message: errorMessage)
                    }
                }
            }
        }
    }
    
    func handleRegisterSuccess() {
        print("Register successful.")
        
        // Save the email to UserDefaults
        if let email = emailTextField.text {
            UserDefaults.standard.set(email, forKey: "registeredEmail")
        }
        
        // Present OTP view controller
        OTPViewController.present(from: self)
    }
    
    func validate(username: String, email: String, password: String, confirmPassword: String) -> Bool {
        // Check if username is valid (e.g., between 3 and 15 characters)
        if username.count < 3 || username.count > 15 {
            showAlert(title: "Validation Error", message: "Username must be between 3 and 15 characters long.")
            return false
        }
        
        // Check if fields are empty
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert(title: "Validation Error", message: "All fields must be filled.")
            return false
        }
        
        // Validate email format
        let emailRegEx = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPred = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            showAlert(title: "Validation Error", message: "Please enter a valid email address.")
            return false
        }
        
        // Password length check (e.g., at least 6 characters)
        if password.count < 6 {
            showAlert(title: "Validation Error", message: "Password must be at least 6 characters long.")
            return false
        }
        
        // Confirm password check
        if password != confirmPassword {
            showAlert(title: "Validation Error", message: "Passwords do not match.")
            return false
        }
        
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Hidden text for password
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
    
    @objc func navigateToLogin() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}
