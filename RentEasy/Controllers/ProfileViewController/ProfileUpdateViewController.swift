import UIKit
import SDWebImage


class ProfileUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let profileUpdateView = ProfileUpdateView()
    private var selectedImage: UIImage?
    private var isCoverImage = false
    private var coverPhotosData: [Data] = []
    private var profilePhotosData: [Data] = []
    private var userInfo: UserInfo?

    // Default images
    private let defaultProfileImage =  UIImage(systemName: "person.crop.circle.fill")
    private let defaultCoverImage = UIImage(named: "photo.badge.plus.fill")

    // Gray background color for cover image
    private let grayBackgroundColor = UIColor.gray

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update Profile"
        
        setupView()
        populateUserData()
        
        // Register for keyboard notifications
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Dismiss keybaord
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Initialize with user data
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(profileUpdateView)
        profileUpdateView.delegate = self
        
        profileUpdateView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func populateUserData() {
        guard let userInfo = userInfo else { return }
        
        profileUpdateView.usernameTextField.text = userInfo.username
        profileUpdateView.emailTextField.text = userInfo.email
        profileUpdateView.bioTextView.text = userInfo.bio
        profileUpdateView.locationTextField.text = userInfo.location
        
        // Set profile image and icon color
        if !userInfo.profilePhoto.isEmpty {
            let profilePhotoURL = URL(string: userInfo.profilePhoto)
            profileUpdateView.profileImageView.sd_setImage(with: profilePhotoURL, completed: nil)
        } else {
            profileUpdateView.profileImageView.image = defaultProfileImage
            profileUpdateView.profileImageView.backgroundColor = ColorManagerUtilize.shared.lightGray
        }

        // Set cover image and icon color
        if !userInfo.coverPhoto.isEmpty {
            let coverPhotoURL = URL(string: userInfo.coverPhoto)
            profileUpdateView.coverImageView.sd_setImage(with: coverPhotoURL, completed: nil)
            profileUpdateView.coverImageView.backgroundColor = .clear
        } else {
            profileUpdateView.coverImageView.image = defaultCoverImage
            profileUpdateView.coverImageView.backgroundColor = ColorManagerUtilize.shared.lightGray
        }

        // Set icon color
        profileUpdateView.profileImageView.tintColor = ColorManagerUtilize.shared.deepCharcoal
    }


    private func checkPhotoLibraryPermission(forCoverImage: Bool) {
        PhotoPrivacyManager.checkPhotoLibraryPermission { [weak self] granted in
            if granted {
                self?.selectImage(forCoverImage: forCoverImage)
            } else {
                self?.showAccessAlert()
            }
        }
    }
    
    private func showAccessAlert() {
        PhotoPrivacyManager.showAccessAlert(from: self)
    }
    
    private func selectImage(forCoverImage: Bool) {
        isCoverImage = forCoverImage
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            if isCoverImage {
                profileUpdateView.coverImageView.image = image
                profileUpdateView.coverImageView.backgroundColor = .clear
            } else {
                profileUpdateView.profileImageView.image = image
            }
            updateImageData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateImageData() {
        if isCoverImage {
            if let coverImage = profileUpdateView.coverImageView.image {
                if let coverImageData = convertImageToData(coverImage) {
                    coverPhotosData = [coverImageData]
                }
            }
        } else {
            if let profileImage = profileUpdateView.profileImageView.image {
                if let profileImageData = convertImageToData(profileImage) {
                    profilePhotosData = [profileImageData]
                }
            }
        }
    }
    
    private func convertImageToData(_ image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.8)
    }
    
    // MARK: - Keyboard Notifications
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        profileUpdateView.saveButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-keyboardHeight - 0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        profileUpdateView.saveButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
   }
}

// MARK: - ProfileUpdateViewDelegate
extension ProfileUpdateViewController: UpdateProfileViewDelegate {
    
    func didTapUpdatePicture() {
        checkPhotoLibraryPermission(forCoverImage: false) // For profile image
    }

    func didTapUpdateCoverPicture() {
        checkPhotoLibraryPermission(forCoverImage: true) // For cover image
    }
    
    func didTapSaveButton() {
        guard let profileInfo = getUpdatedProfileInfo() else {
            showAlert(title: "Error", message: "Failed to gather profile info")
            return
        }
        LoadingOverlay.shared.show(over: self.view)
        
        APICaller.updateUserProfile(
            profile: profileInfo,
            coverPhoto: coverPhotosData,
            profilePhoto: profilePhotosData
        ) { [weak self] result in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hide()
                
                switch result {
                case .success(let response):
                    print("Profile updated successfully: \(response.message)")
                    self?.showAlert(title: "Success", message: response.message)
                      
                case .failure(let error):
                    print("Failed to update profile: \(error.localizedDescription)")
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    private func getUpdatedProfileInfo() -> UpdateProfile? {
        let username = profileUpdateView.usernameTextField.text ?? ""
        let email = profileUpdateView.emailTextField.text ?? ""
        let bio = profileUpdateView.bioTextView.text
        let location = profileUpdateView.locationTextField.text
        
        return UpdateProfile(username: username, email: email, bio: bio, location: location)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
}

