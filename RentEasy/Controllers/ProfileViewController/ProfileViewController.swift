import UIKit
import SnapKit

class ProfileViewController: UIViewController, ProfileViewDelegate {
    
    private let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Set delegate
        profileView.delegate = self
        
        // Hide the default back button
        self.navigationItem.hidesBackButton = true
        
        // Set up custom back button
        let backButtonImage = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        // Set up settings button on the right
        let settingsImage = UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        self.navigationItem.rightBarButtonItem = settingsButton
        
        // Set large title display mode
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        // Set navigation bar tint color to gray
        self.navigationController?.navigationBar.tintColor = .black
        
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        APICaller.getUserInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfo):
                    self?.profileView.updateProfile(with: userInfo)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }

    private func handleError(_ error: NetworkError) {
        // Handle error appropriately, e.g., show an alert
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
        print("Settings button tapped")
    }
    
    // MARK: - ProfileViewDelegate
    func didTapUpdateProfile() {
        let updateProfileVC = UpdateViewController()
        navigationController?.pushViewController(updateProfileVC, animated: true)
    }
    
    func didTapShareProfile() {
        let shareProfileVC = ShareProfileViewController()
        let navController = UINavigationController(rootViewController: shareProfileVC)
        present(navController, animated: true, completion: nil)
        
    }
}
