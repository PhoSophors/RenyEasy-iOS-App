import UIKit
import SnapKit

class PostDetailCollectionViewCell: UICollectionViewCell {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        // Initial constraints for imageView
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(imageView.snp.width).multipliedBy(9.0 / 16.0)
        }
    }

    func configure(with imageUrl: String?) {
        if let url = imageUrl {
            imageView.loadImage(from: url) { [weak self] image in
                guard let self = self, let image = image else { return }
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }

}
