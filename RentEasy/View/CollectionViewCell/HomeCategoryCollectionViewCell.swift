import UIKit
import SnapKit

protocol HomeCategoryCollectionViewCellDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCategoryCollectionViewCell"
    
    private let categories = [
        "House": "house",
        "Apartment": "apartment",
        "Hotel": "hotel",
        "Villa": "villa",
        "Condo": "condo",
        "Townhouse": "townhouse",
        "Room": "room"
    ]
    
    weak var delegate: HomeCategoryCollectionViewCellDelegate?
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        contentView.addSubview(categoryCollectionView)
        
        categoryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HomeCategoryCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)

        // Clear previous content
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        // Configure the cell
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        let categoryName = Array(categories.keys)[indexPath.item]
        label.text = categoryName
        label.sizeToFit()
        label.frame = cell.contentView.bounds.insetBy(dx: 10, dy: 10)
        cell.contentView.addSubview(label)

        cell.contentView.backgroundColor = ColorManagerUtilize.shared.deepGreen
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategoryDisplayName = Array(categories.keys)[indexPath.item]
        let selectedCategoryValue = categories[selectedCategoryDisplayName] ?? ""
        delegate?.didSelectCategory(selectedCategoryValue)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Convert the dictionary keys to an array to use with the index
        let categoryNames = Array(categories.keys)
        
        // Access the category name using the index
        let categoryName = categoryNames[indexPath.item]
        
        // Configure the label
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = categoryName
        label.sizeToFit()
        
        let desiredHeight: CGFloat = 40
        
        return CGSize(width: label.frame.width + 20, height: desiredHeight)
    }
}
