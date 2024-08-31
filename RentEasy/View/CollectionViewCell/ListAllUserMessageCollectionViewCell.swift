import UIKit
import SnapKit
import SDWebImage

class ListAllUserMessageCollectionViewCell: UICollectionViewCell {

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
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
        contentView.addSubview(lastMessageLabel)
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(50)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(15)
        }
        
        lastMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.top.equalTo(usernameLabel.snp.bottom)
            make.trailing.equalTo(contentView).inset(8)
            make.bottom.equalTo(contentView).inset(15)
        }
    }
    
    func configure(with user: UserInfo, message: MessageModel) {
        usernameLabel.text = user.username
        
        let isCurrentUserMessage = message.receiverId == user.id
               
        if isCurrentUserMessage {
            lastMessageLabel.text = "You: \(message.content)"
        } else {
            lastMessageLabel.text = message.content
        }
    
        if let url = URL(string: user.profilePhoto), !user.profilePhoto.isEmpty {
            profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }



}
