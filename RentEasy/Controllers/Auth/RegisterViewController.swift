
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.roundCorners([.topLeft, .topRight], radius: 30)
        
        usernameTextField.roundCorners([.allCorners], radius: 10)
        emailTextField.roundCorners([.allCorners], radius: 10)
        passwordTextField.roundCorners([.allCorners], radius: 10)
        confirmPasswordTextField.roundCorners([.allCorners], radius: 10)
        
        registerBtn.roundCorners([.allCorners], radius: 10)
        registerBtn.backgroundColor = .systemIndigo
        
        // Add tap gesture recognizer to registerLabel
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToLogin))
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(tapGesture)
       
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func navigateToLogin() {
        // Instantiate RegisterViewController from XIB
        let registerVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        registerVC.modalPresentationStyle = .fullScreen // or .overFullScreen for a different effect
        self.present(registerVC, animated: true, completion: nil)
    }
}

