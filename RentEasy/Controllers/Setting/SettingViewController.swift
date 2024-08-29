import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        view.addSubview(logoutButton)

        setupTableView()
        setupLogoutButton()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(logoutButton.snp.top).offset(-20)
        }
    }

    private func setupLogoutButton() {
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.tintColor = .white
        logoutButton.layer.cornerRadius = 25
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }

    @objc private func logoutButtonTapped(_ sender: UIButton) {
        showLogoutConfirmationAlert()
    }

    private func showLogoutConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Confirm Logout",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.handleLogout()
        }
        alertController.addAction(logoutAction)

        present(alertController, animated: true, completion: nil)
    }

    private func handleLogout() {
        AuthManager.clearToken()
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: cell.textLabel?.text = "Edit profile"
            case 1: cell.textLabel?.text = "Change password"
            case 2: cell.textLabel?.text = "Your preferences"
            case 3: cell.textLabel?.text = "Invite friends"
            default: break
            }
            cell.accessoryType = .disclosureIndicator
        } else {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Recommendations"
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(true, animated: true)
                cell.accessoryView = switchView
            case 1:
                cell.textLabel?.text = "Use the partner's information"
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(false, animated: true)
                cell.accessoryView = switchView
            case 2:
                cell.textLabel?.text = "Recommendations"
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(true, animated: true)
                cell.accessoryView = switchView
            case 3:
                cell.textLabel?.text = "Use the partner's information"
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(true, animated: true)
                cell.accessoryView = switchView
            default: break
            }
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Handle navigation based on the selected cell
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            print("Edit profile tapped")
        case (0, 1):
            navigateToForgotPassword()
        case (0, 2):
            print("Your preferences tapped")
        case (0, 3):
            print("Invite friends tapped")
        default:
            break
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Account" : "Notifications"
    }

    // MARK: - Navigation
    private func navigateToForgotPassword() {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        if let forgotPasswordVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            self.present(forgotPasswordVC, animated: true, completion: nil)
            print("Forgot password label tapped..!")
        } else {
            print("ForgotPasswordViewController not found in storyboard")
        }
    }
}
