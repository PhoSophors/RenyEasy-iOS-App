import UIKit
import SnapKit

class PostView: UIView {

    private let scrollView: UIScrollView
    private let contentView: UIView
    
    let photoCollectionView: UICollectionView
    let addPhotoButton: UIButton
    
    override init(frame: CGRect) {
        scrollView = UIScrollView()
        contentView = UIView()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        photoCollectionView.layer.borderWidth = 0.5
        photoCollectionView.layer.cornerRadius = 5
        
        addPhotoButton = UIButton(type: .system)
        
        super.init(frame: frame)
        
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddPhotoButton() {
        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.backgroundColor = ColorManagerUtilize.shared.forestGreen
        addPhotoButton.setTitleColor(.white, for: .normal)
        addPhotoButton.layer.cornerRadius = 5
        addPhotoButton.clipsToBounds = true
    }
    
    private func setupViewAndConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(photoCollectionView)
        contentView.addSubview(addPhotoButton)
        
        setupAddPhotoButton()

        // Set up constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(photoCollectionView.snp.width).multipliedBy(0.65)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom).offset(20)
            make.centerX.equalTo(contentView)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
}
