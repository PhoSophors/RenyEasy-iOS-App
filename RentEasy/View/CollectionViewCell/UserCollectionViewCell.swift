import UIKit
import SDWebImage // Make sure to add SDWebImage to your project via CocoaPods, Carthage, or Swift Package Manager

class UserCollectionViewCell: UICollectionViewCell {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray // Placeholder color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(8)
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(8)
        }
    }
    
    func configure(with user: UserInfo) {
        profileImageView.sd_setImage(with: URL(string: user.profilePhoto), placeholderImage: UIImage(named: "placeholder")) // Use SDWebImage to load image from URL
        nameLabel.text = user.username
    }
}
