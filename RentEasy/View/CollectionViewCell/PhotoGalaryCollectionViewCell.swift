import UIKit
import SnapKit

protocol PhotoGalaryCollectionViewCellDelegate: AnyObject {
    func didTapRemoveButton(cell: PhotoGalaryCollectionViewCell)
}

class PhotoGalaryCollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 1
        imgView.isHidden = true
        return imgView
    }()
    
    let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
        return button
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .red
        button.backgroundColor = .white
        button.layer.cornerRadius = 10

        // Ensure the shadow isn't clipped
        button.clipsToBounds = false
        button.layer.masksToBounds = false
        
        return button
    }()

    
    weak var delegate: PhotoGalaryCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
        contentView.addSubview(addPhotoButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(30)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        removeButton.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage, isRemovable: Bool) {
        imageView.image = image
        imageView.isHidden = false
        removeButton.isHidden = !isRemovable
        addPhotoButton.isHidden = true 
    }


    
    @objc private func didTapRemove() {
        delegate?.didTapRemoveButton(cell: self)
    }
    
    func getImageView() -> UIImageView {
        return imageView
    }
}
