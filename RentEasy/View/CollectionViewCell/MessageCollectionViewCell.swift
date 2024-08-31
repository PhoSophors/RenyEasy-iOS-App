import UIKit
import SnapKit
import SDWebImage

class MessageCollectionViewCell: UICollectionViewCell {

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = ColorManagerUtilize.shared.lightGray
        imageView.tintColor = ColorManagerUtilize.shared.deepCharcoal
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
//        contentView.addSubview(contentLabel)
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(50)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(8)
        }
        
//        contentLabel.snp.makeConstraints { make in
//            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
//            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
//            make.trailing.equalTo(contentView).inset(8)
//        }
    }


    func configure(with user: UserInfo) {
        usernameLabel.text = user.username

        if let url = URL(string: user.profilePhoto), !user.profilePhoto.isEmpty {
            profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }

}
