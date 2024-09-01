import UIKit
import SnapKit
import SDWebImage

class MessageCollectionViewCell: UICollectionViewCell {

    private let receiverProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = ColorManagerUtilize.shared.lightGray
        imageView.tintColor = ColorManagerUtilize.shared.deepCharcoal
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let receiverMessageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let receiverMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let senderProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = ColorManagerUtilize.shared.lightGray
        imageView.tintColor = ColorManagerUtilize.shared.deepCharcoal
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let senderMessageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let senderMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(receiverProfileImageView)
        contentView.addSubview(receiverMessageContainerView)
        receiverMessageContainerView.addSubview(receiverMessageLabel)
        contentView.addSubview(senderProfileImageView)
        contentView.addSubview(senderMessageContainerView)
        senderMessageContainerView.addSubview(senderMessageLabel)
    }

    private func setupConstraints() {
        // Constraints for receiver profile image and message container view
        receiverProfileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
        }

        receiverMessageContainerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(60)
            make.trailing.equalTo(receiverProfileImageView.snp.leading).offset(-8)
            make.centerY.equalTo(contentView)
        }

        receiverMessageLabel.snp.makeConstraints { make in
            make.edges.equalTo(receiverMessageContainerView).inset(10)
        }

        // Constraints for sender profile image and message container view
        senderProfileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
        }

        senderMessageContainerView.snp.makeConstraints { make in
            make.leading.equalTo(senderProfileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(60)
            make.centerY.equalTo(contentView)
        }

        senderMessageLabel.snp.makeConstraints { make in
            make.edges.equalTo(senderMessageContainerView).inset(10)
        }

        // Hide sender components initially
        senderProfileImageView.isHidden = true
        senderMessageContainerView.isHidden = true
        
        senderMessageContainerView.backgroundColor = .red
    }

    func configure(with user: UserInfo, message: MessageModel) {
        let isReceiverUserMessage = message.receiverId == user.id

        if isReceiverUserMessage {
            receiverMessageLabel.text = message.content
            receiverMessageContainerView.backgroundColor = ColorManagerUtilize.shared.deepGreen
            receiverMessageLabel.textColor = ColorManagerUtilize.shared.white
            receiverMessageLabel.textAlignment = .left

            if let url = URL(string: user.profilePhoto), !user.profilePhoto.isEmpty {
                receiverProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                receiverProfileImageView.image = UIImage(systemName: "person.circle.fill")
            }

            // Hide sender components
            senderProfileImageView.isHidden = true
            senderMessageContainerView.isHidden = true
            receiverProfileImageView.isHidden = false
            receiverMessageContainerView.isHidden = false

        } else {
            senderMessageLabel.text = message.content
            senderMessageContainerView.backgroundColor = ColorManagerUtilize.shared.lightGray
            senderMessageLabel.textColor = ColorManagerUtilize.shared.deepCharcoal
            senderMessageLabel.textAlignment = .left

            if let url = URL(string: user.profilePhoto), !user.profilePhoto.isEmpty {
                senderProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                senderProfileImageView.image = UIImage(systemName: "person.circle.fill")
            }

            // Hide receiver components
            receiverProfileImageView.isHidden = true
            receiverMessageContainerView.isHidden = true
            senderProfileImageView.isHidden = false
            senderMessageContainerView.isHidden = false
        }
    }
    
    
}
