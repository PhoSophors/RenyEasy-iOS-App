import UIKit
import SnapKit

class ProfileViewController: UIViewController, ProfileViewDelegate {

    private let profileView = ProfileView()
    private let userViewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Set delegate
        profileView.delegate = self

        // Set up settings button on the right
        let settingsImage = UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        self.navigationItem.rightBarButtonItem = settingsButton

        // Set large title display mode
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        // Set navigation bar tint color to gray
        self.navigationController?.navigationBar.tintColor = .black

        // Bind ViewModel
        bindViewModel()

        // Fetch user info
        userViewModel.fetchUserInfo()
    }

    private func bindViewModel() {
        userViewModel.onUserInfoFetched = { [weak self] in
            guard let userInfo = self?.userViewModel.userInfo else { return }
            self?.profileView.updateProfile(with: userInfo)
        }

        userViewModel.onError = { [weak self] error in
            self?.handleError(error as! NetworkError)
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
        print("Settings button tapped")
    }

    // MARK: - ProfileViewDelegate
    func didTapUpdateProfile() {
        let updateProfileVC = ProfileUpdateViewController()
        navigationController?.pushViewController(updateProfileVC, animated: true)
    }

    func didTapShareProfile() {
        let shareProfileVC = ShareProfileViewController()
        let navController = UINavigationController(rootViewController: shareProfileVC)
        present(navController, animated: true, completion: nil)
    }
}
