import UIKit
import SnapKit

class MainMessageViewController: UIViewController {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No messages yet."
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Message"

        view.backgroundColor = .white
        setupNavigationBar()
        setupMessageLabel()
    }
    
    private func setupNavigationBar() {
        // Set up the add user button
        let addUserImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        let addUserButton = UIButton(type: .custom)
        addUserButton.setImage(addUserImage, for: .normal)
        addUserButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        addUserButton.layer.cornerRadius = 20
        addUserButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        addUserButton.addTarget(self, action: #selector(addUserButtonTapped), for: .touchUpInside)
    
        // Create UIBarButtonItem instances
        let addUserBarButtonItem = UIBarButtonItem(customView: addUserButton)
        
        // Set the right bar button items
        self.navigationItem.rightBarButtonItems = [addUserBarButtonItem]
        
        // Customize navigation bar appearance
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationController?.navigationBar.isTranslucent = false
    }

    private func setupMessageLabel() {
        // Add the label to the view
        view.addSubview(messageLabel)
        
        // Set up constraints using SnapKit
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.leading.equalTo(view).inset(20)
            make.trailing.equalTo(view).inset(20)
        }
    }
    
    // MARK: - Action
    @objc private func addUserButtonTapped() {
        let addUserVC = AddUserViewController()
        let navController = UINavigationController(rootViewController: addUserVC)
        present(navController, animated: true, completion: nil)
    }

}
