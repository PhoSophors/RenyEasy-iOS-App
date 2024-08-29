import UIKit
import SnapKit

class ProfileViewController: UIViewController, ProfileViewDelegate {

    private let profileView = ProfileView()
    private let userViewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        setupNavigationBar()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        userViewModel.fetchUserInfo()
    }

    private func setupViews() {
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileView.delegate = self
    }

    private func setupNavigationBar() {
        let settingsImage = UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        self.navigationItem.rightBarButtonItem = settingsButton
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .black
    }

    private func bindViewModel() {
        LoadingOverlay.shared.show(over: self.view)
        userViewModel.onUserInfoFetched = { [weak self] in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hide()
                guard let userInfo = self?.userViewModel.userInfo else { return }
                self?.profileView.updateProfile(with: userInfo)
            }
        }

        userViewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hide()
                self?.handleError(error as! NetworkError)
            }
        }
    }
   
    private func handleError(_ error: NetworkError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func settingsButtonTapped() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }

    // MARK: - ProfileViewDelegate
    func didTapUpdateProfile() {
        guard let userInfo = userViewModel.userInfo else {
            showAlert(title: "Error", message: "User profile information is not available.")
            return
        }
//        let profileUpdateViewController = ProfileUpdateViewController(userInfo: userInfo)
//        let navController = UINavigationController(rootViewController: profileUpdateViewController)
//        present(navController, animated: true, completion: nil)
        let profileVC = ProfileUpdateViewController(userInfo: userInfo)
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }

    func didTapShareProfile() {
        let shareProfileVC = ShareProfileViewController()
        let navController = UINavigationController(rootViewController: shareProfileVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default))
       present(alert, animated: true)
   }
}
