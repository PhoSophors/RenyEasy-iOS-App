import UIKit
import SnapKit
import SDWebImage

protocol ProfileViewDelegate: AnyObject {
    func didTapUpdateProfile()
    func didTapShareProfile()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Elements
    private let coverImageView = UIImageView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let bioLabel = UILabel()
    private let locationLabel = UILabel()
    private let followersLabel = UILabel()
    private let updateProfileButton = UIButton(type: .system)
    private let shareProfileButton = UIButton(type: .system)
    
    private let photoIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.isHidden = true
        return imageView
    }()
    
    private let addCoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Your Cover"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
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
        setupCoverImageView()
        setupProfileImageView()
        setupNameLabel()
        setupBioLabel()
        setupLocationLabel()
        setupFollowersLabel()
        setupUpdateProfileButton()
        setupShareProfileButton()
    }
    
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
    
    private func setupCoverImageView() {
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-50)
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
    
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 75
        profileImageView.backgroundColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(-75)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(150)
        }
    }
    
    private func setupNameLabel() {
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    private func setupBioLabel() {
        bioLabel.textAlignment = .left
        bioLabel.numberOfLines = 3
        bioLabel.lineBreakMode = .byTruncatingTail
        bioLabel.font = UIFont.systemFont(ofSize: 14)
        bioLabel.textColor = .gray
        contentView.addSubview(bioLabel)
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            // Removed width constraint to avoid conflict
        }
    }

    private func setupLocationLabel() {
        locationLabel.textAlignment = .left
        locationLabel.numberOfLines = 2
        locationLabel.lineBreakMode = .byTruncatingTail
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(locationLabel)

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func setupFollowersLabel() {
        followersLabel.textAlignment = .left
        followersLabel.font = UIFont.systemFont(ofSize: 14)
        followersLabel.textColor = ColorManagerUtilize.shared.forestGreen
        contentView.addSubview(followersLabel)
        
        followersLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func setupUpdateProfileButton() {
        configureButton(updateProfileButton, title: " Edit profile", imageName: "pencil")
        contentView.addSubview(updateProfileButton)
        
        updateProfileButton.snp.makeConstraints { make in
            make.top.equalTo(followersLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        updateProfileButton.addTarget(self, action: #selector(updateProfileTapped), for: .touchUpInside)
    }
    
    private func setupShareProfileButton() {
        configureButton(shareProfileButton, title: " Share profile", imageName: "square.and.arrow.up")
        contentView.addSubview(shareProfileButton)
        
        shareProfileButton.snp.makeConstraints { make in
            make.top.equalTo(followersLabel.snp.bottom).offset(20)
            make.left.equalTo(updateProfileButton.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(updateProfileButton.snp.width)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        shareProfileButton.addTarget(self, action: #selector(shareProfileTapped), for: .touchUpInside)
    }
    
    private func configureButton(_ button: UIButton, title: String, imageName: String) {
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.backgroundColor = ColorManagerUtilize.shared.forestGreen
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    // MARK: - Update Profile with User Info
    func updateProfile(with userInfo: UserInfo) {
        updateProfileImage(with: userInfo.profilePhoto)
        updateCoverImage(with: userInfo.coverPhoto)
        
        nameLabel.text = userInfo.username
        bioLabel.text = userInfo.bio
        locationLabel.text = userInfo.location
        followersLabel.text = "Followers: 322 • Posts: 2"
    }
    
    private func updateProfileImage(with urlString: String) {
        if let profileUrl = URL(string: urlString) {
            profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        
        profileImageView.tintColor = .gray
    }
    
    private func updateCoverImage(with urlString: String) {
        if let coverUrl = URL(string: urlString) {
            coverImageView.sd_setImage(with: coverUrl) { [weak self] image, error, _, _ in
                if image == nil || error != nil {
                    self?.showPlaceholderOnCoverImageView()
                } else {
                    self?.hidePlaceholderOnCoverImageView()
                }
            }
        } else {
            showPlaceholderOnCoverImageView()
        }
    }
    
    private func showPlaceholderOnCoverImageView() {
        coverImageView.backgroundColor = .systemGray6
        photoIconImageView.isHidden = false
        addCoverLabel.isHidden = false
    }
    
    private func hidePlaceholderOnCoverImageView() {
        coverImageView.backgroundColor = .clear
        photoIconImageView.isHidden = photoIconImageView.isHidden == true
        addCoverLabel.isHidden = true
    }
    
    // MARK: - Button Actions
    @objc private func updateProfileTapped() {
        delegate?.didTapUpdateProfile()
    }
    
    @objc private func shareProfileTapped() {
        delegate?.didTapShareProfile()
    }
}
