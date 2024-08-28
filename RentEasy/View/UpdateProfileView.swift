import UIKit
import SnapKit
import SDWebImage

protocol UpdateProfileViewDelegate: AnyObject {
    func didTapUpdatePicture()
    func didTapUpdateCoverPicture()
    func didTapSaveButton()
}

class ProfileUpdateView: UIView {
    weak var delegate: UpdateProfileViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Elements
    let profileImageView = UIImageView()
    let coverImageView = UIImageView()
    let usernameTextField = UITextField()
    let emailTextField = UITextField()
    let locationTextField = UITextField()
    let bioTextField = UITextField()
    
    private var profilePictureLabelStackView: UIStackView?
    private var coverPictureLabelStackView: UIStackView?
    private var locationLabelStackView: UIStackView?
    private var bioLabelStackView: UIStackView?
    
    let photoIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.isHidden = true
        return imageView
    }()
    
    let addCoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Your Cover"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = ColorManagerUtilize.shared.forestGreen
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
        bioLabelView()
        setupBioTextField()
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        profilePictureLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Profile picture setup
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 75
        profileImageView.backgroundColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.gray.cgColor
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        coverPictureLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Cover picture setup
    private func setupCoverImageView() {
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        
        // Add a tap gesture recognizer to coverImageView
       let coverTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCoverImageView))
       coverImageView.isUserInteractionEnabled = true
       coverImageView.addGestureRecognizer(coverTapGesture)
        
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(coverPictureLabelStackView!.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        coverImageView.addSubview(photoIconImageView)
        coverImageView.addSubview(addCoverLabel)
        
        photoIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        addCoverLabel.snp.makeConstraints { make in
            make.top.equalTo(photoIconImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    // Bio label setup
    private func bioLabelView() {
        let label = UILabel()
        label.text = "Bio"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        bioLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Bio text field setup
    private func setupBioTextField() {
        bioTextField.borderStyle = .roundedRect
        contentView.addSubview(bioTextField)
        
        guard let bioLabelStackView = bioLabelStackView else { return }

        bioTextField.snp.makeConstraints { make in
            make.top.equalTo(bioLabelStackView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(40)
        }
    }
    
    // Location label setup
    private func locationLabelView() {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        locationLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(bioTextField.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Location text field setup
    private func setupLocationTextField() {
        locationTextField.borderStyle = .roundedRect
        contentView.addSubview(locationTextField)
        
        guard let locationLabelStackView = locationLabelStackView else { return }

        locationTextField.snp.makeConstraints { make in
            make.top.equalTo(locationLabelStackView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(40)
        }
    }
    
    // Save button setup
    private func setupSaveButton() {
        contentView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(locationTextField.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-20)
            make.height.equalTo(50)
        }
    }
    
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

