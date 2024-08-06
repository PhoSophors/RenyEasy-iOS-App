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
    private let updateProfile = UIButton(type: .system)
    private let shareProfile = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Set background color
        backgroundColor = .white
        
        // Add and configure the scroll view
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // Configure and add UI elements
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-50)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        profileImageView.layer.cornerRadius = 75
        profileImageView.backgroundColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.systemIndigo.cgColor
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(-75)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(150)
        }
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
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
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        locationLabel.textAlignment = .left
        locationLabel.numberOfLines = 2
        locationLabel.lineBreakMode = .byTruncatingTail
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(locationLabel)

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.right.equalToSuperview().offset(-20)
        }

        followersLabel.textAlignment = .left
        followersLabel.font = UIFont.systemFont(ofSize: 14)
        followersLabel.textColor = .blue
        contentView.addSubview(followersLabel)
        
        followersLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        updateProfile.setTitle("Edit profile", for: .normal)
        updateProfile.backgroundColor = .systemIndigo
        updateProfile.tintColor = .white
        updateProfile.layer.cornerRadius = 8
        contentView.addSubview(updateProfile)
        
        updateProfile.snp.makeConstraints { make in
            make.top.equalTo(followersLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        updateProfile.addTarget(self, action: #selector(updateProfileTapped), for: .touchUpInside)
        
        shareProfile.setTitle("Share profile", for: .normal)
        shareProfile.backgroundColor = .systemIndigo
        shareProfile.tintColor = .white
        shareProfile.layer.cornerRadius = 8
        contentView.addSubview(shareProfile)
        
        shareProfile.snp.makeConstraints { make in
            make.top.equalTo(followersLabel.snp.bottom).offset(20)
            make.left.equalTo(updateProfile.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(updateProfile.snp.width)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        shareProfile.addTarget(self, action: #selector(shareProfileTapped), for: .touchUpInside)
    }
    
    // MARK: Update Profile with User Info
    func updateProfile(with userInfo: UserInfo) {
        print("User info: \(userInfo)")
        if let profileUrl = URL(string: userInfo.profilePhoto) {
            profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        
        // Update cover image or background color
       if let coverUrl = URL(string: userInfo.coverPhoto) {
           coverImageView.sd_setImage(with: coverUrl) { [weak self] image, error, _, _ in
               if image == nil || error != nil {
                   // If image is nil or there was an error, set background color
                   self?.coverImageView.backgroundColor = .systemGray6
               } else {
                   // If the image was successfully loaded, ensure the background color is clear
                   self?.coverImageView.backgroundColor = .clear
               }
           }
       } else {
           coverImageView.backgroundColor = .systemGray6
       }
        
        nameLabel.text = userInfo.username
        bioLabel.text = userInfo.bio
        locationLabel.text = userInfo.location
        followersLabel.text = "Followers: 322 . Posts: 20"
    }

    // MARK: Navigation to update profile
    @objc private func updateProfileTapped() {
        delegate?.didTapUpdateProfile()
    }
    
    @objc private func shareProfileTapped() {
        delegate?.didTapShareProfile()
    }
}
