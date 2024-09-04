import UIKit
import SnapKit
import SDWebImage

protocol UpdateProfileViewDelegate: AnyObject {
    func didTapUpdatePicture()
    func didTapUpdateCoverPicture()
    func didTapSaveButton()
}

class ProfileUpdateView: UIView, UITextViewDelegate, UITextFieldDelegate {
    weak var delegate: UpdateProfileViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Elements
    let profileImageView = UIImageView()
    let coverImageView = UIImageView()
    let usernameTextField = UITextField()
    let emailTextField = UITextField()
    let locationTextField = UITextField()
    let bioTextView = UITextView()
    
    private var profilePictureLabelStackView: UIStackView?
    private var coverPictureLabelStackView: UIStackView?
    private var usernameLabelStackView: UIStackView?
    private var emailLabelStackView: UIStackView?
    private var locationLabelStackView: UIStackView?
    private var bioLabelStackView: UIStackView?
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = ColorManagerUtilize.shared.deepGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        setupScrollView()
        
        profilePictureLabelView()
        setupProfileImageView()
        
        coverPictureLabelView()
        setupCoverImageView()
        
        usernameLabelView()
        setupUsernameTextField()
        
        emailLabelView()
        setupEmailTextField()
        
        bioLabelView()
        setupBioTextView()
        
        locationLabelView()
        setupLocationTextField()
        
        setupSaveButton()
    }
    
    // Scroll view setup
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // Profile label setup
    private func profilePictureLabelView() {
        let label = UILabel()
        label.text = "Profile picture"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTabProfileImageView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapGesture)
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        profilePictureLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    // Profile picture setup
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 75
        profileImageView.backgroundColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = ColorManagerUtilize.shared.deepGreen.cgColor
        contentView.addSubview(profileImageView)
        
        // Add a tap gesture recognizer to coverImageView
       let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTabProfileImageView))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileTapGesture)
        
        guard let profilePictureLabelStackView = profilePictureLabelStackView else { return }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profilePictureLabelStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
  
    // Cover label setup
    private func coverPictureLabelView() {
        let label = UILabel()
        label.text = "Cover picture"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCoverImageView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapGesture)
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        
        coverPictureLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    // Cover picture setup
    private func setupCoverImageView() {
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 10
        coverImageView.layer.borderWidth = 1.0
        coverImageView.layer.borderColor = ColorManagerUtilize.shared.deepGreen.cgColor
        contentView.addSubview(coverImageView)
        
        // Add a tap gesture recognizer to coverImageView
       let coverTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCoverImageView))
       coverImageView.isUserInteractionEnabled = true
       coverImageView.addGestureRecognizer(coverTapGesture)
        
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(coverPictureLabelStackView!.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.height.equalTo(200)
        }
    }
    
    // Username label setup
    private func usernameLabelView() {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        usernameLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    // Bio text field setup
    private func setupUsernameTextField() {
        usernameTextField.backgroundColor = ColorManagerUtilize.shared.lightGray
        usernameTextField.layer.borderColor = UIColor.clear.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: usernameTextField.frame.height))
        usernameTextField.delegate = self
        contentView.addSubview(usernameTextField)
        
        guard let usernameLabelStackView = usernameLabelStackView else { return }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabelStackView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.height.equalTo(40)
        }
    }
    
    // Email label setup
    private func emailLabelView() {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        emailLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    private func setupEmailTextField() {
        emailTextField.backgroundColor = ColorManagerUtilize.shared.lightGray
        emailTextField.layer.borderColor = UIColor.clear.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 10
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTextField.frame.height))
        emailTextField.textColor = .gray
        emailTextField.isEnabled = false
        emailTextField.delegate = self

        let iconContainerView = UIView()
        iconContainerView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "lock.circle.fill")
        iconImageView.tintColor = .gray
        iconImageView.contentMode = .scaleAspectFit

        iconContainerView.addSubview(iconImageView)

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }

        emailTextField.rightView = iconContainerView
        emailTextField.rightViewMode = .always

        contentView.addSubview(emailTextField)
        guard let emailLabelStackView = emailLabelStackView else { return }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabelStackView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.height.equalTo(40)
        }
    }
    
    // Bio label setup
    private func bioLabelView() {
        let label = UILabel()
        label.text = "Bio"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        bioLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }

    // Bio text view setup
    private func setupBioTextView() {
        bioTextView.backgroundColor = ColorManagerUtilize.shared.lightGray
        bioTextView.layer.borderColor = UIColor.clear.cgColor
        bioTextView.layer.borderWidth = 1.0
        bioTextView.layer.cornerRadius = 10
        bioTextView.font = UIFont.systemFont(ofSize: 16)
        bioTextView.delegate = self
        contentView.addSubview(bioTextView)

        guard let bioLabelStackView = bioLabelStackView else { return }

        bioTextView.snp.makeConstraints { make in
            make.top.equalTo(bioLabelStackView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.height.equalTo(120)
        }
    }
    
    // Location label setup
    private func locationLabelView() {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        locationLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(bioTextView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
    }
    
    // Location text field setup
    private func setupLocationTextField() {
        locationTextField.delegate = self
        locationTextField.backgroundColor = ColorManagerUtilize.shared.lightGray
        locationTextField.layer.borderColor = UIColor.clear.cgColor
        locationTextField.layer.borderWidth = 1.0
        locationTextField.layer.cornerRadius = 10
        locationTextField.leftViewMode = .always
        locationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: locationTextField.frame.height))
        contentView.addSubview(locationTextField)
        
        guard let locationLabelStackView = locationLabelStackView else { return }

        locationTextField.snp.makeConstraints { make in
            make.top.equalTo(locationLabelStackView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.height.equalTo(40)
        }
    }
    
    // Save button setup
     private func setupSaveButton() {
        contentView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(locationTextField.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.bottom.equalTo(contentView).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.layer.borderColor = ColorManagerUtilize.shared.deepGreen.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }

    // MARK: - UITextViewDelegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = ColorManagerUtilize.shared.deepGreen.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - Action methods
    
    @objc private func didTabProfileImageView() {
        delegate?.didTapUpdatePicture()
    }
    
    @objc private func didTapCoverImageView() {
       delegate?.didTapUpdateCoverPicture()
   }

    @objc private func didTapSaveButton() {
        delegate?.didTapSaveButton()
    }
}

