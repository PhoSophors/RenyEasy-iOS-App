import UIKit
import SnapKit

class PostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var post: RentPost?
    private let pageControl = UIPageControl()

    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemIndigo
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    // Define the userInfoStackView as a property
    private let userInfoStackView: UIStackView = {
        // User Image View
        let userImageView = UIImageView()
        userImageView.image = UIImage(named: "AppIcon")
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 20
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        // Name Label
        let nameLabel = UILabel()
        nameLabel.text = "RENT EASY"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .black

        // Title Label
        let roleLabel = UILabel()
        roleLabel.text = "Admin"
        roleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        roleLabel.textColor = .gray

        // Stack View for Labels (Vertical)
        let labelStackView = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 2

        // Phone Button
        let phoneButton = UIButton(type: .system)
        phoneButton.setImage(UIImage(systemName: "phone"), for: .normal)
        phoneButton.tintColor = .systemIndigo
        phoneButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        phoneButton.layer.cornerRadius = 20
        phoneButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        let messageButton = UIButton(type: .system)
        messageButton.setImage(UIImage(systemName: "message.fill"), for: .normal)
        messageButton.tintColor = .systemIndigo
        messageButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        messageButton.layer.cornerRadius = 20
        messageButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        // Stack View (Horizontal) for the entire row
        let stackView = UIStackView(arrangedSubviews: [userImageView, labelStackView,messageButton, phoneButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16 // Adjust spacing as needed
        
        // Add background color
        stackView.backgroundColor = UIColor.systemGray6
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        stackView.clipsToBounds = true
        
        return stackView
    }()

    private let propertyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Property Information"
        label.textColor = .systemIndigo
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private func propertyInfoView() -> UIStackView {
        // Create labels for each feature and amenity
        let featureLabels: [(String, String)] = [
            ("Type:", "Villa"),
            ("Last Update:", "2 day ago"),
        ]
        
        // Create an array to hold the stack views for each feature
        var featureViews: [UIStackView] = []
        
        for (labelText, detailText) in featureLabels {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            label.textColor = .gray
            
            let detailLabel = UILabel()
            detailLabel.text = detailText
            detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            detailLabel.textColor = .black
            
            let featureStackView = UIStackView(arrangedSubviews: [label, detailLabel])
            featureStackView.axis = .horizontal
            featureStackView.alignment = .center
            featureStackView.spacing = 8
            
            featureViews.append(featureStackView)
        }
        
        // Create a stack view for all features and amenities
        let featuresStackView = UIStackView(arrangedSubviews: featureViews)
        featuresStackView.axis = .vertical
        featuresStackView.spacing = 10
        
        return featuresStackView
    }

    private let propertyFeatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Property Feature and Amenities"
        label.textColor = .systemIndigo
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
 
    private func propertyFeaturesView() -> UIStackView {
        // Create labels for each feature and amenity
        let featureLabels: [(String, String)] = [
            ("Location:", "Single Villa for rent at Khan Touk Kork"),
            ("Asking price:", "$1800 /Month"),
            ("Land size:", "14 x 22m"),
            ("House size:", "9m x 12m"),
            ("Bedrooms:", "04"),
            ("Bathrooms:", "05"),
            ("Furnished:", "Fully furnished"),
            ("Distance:", "1km from Avenue TK")
        ]
        
        // Create an array to hold the stack views for each feature
        var featureViews: [UIStackView] = []
        
        for (labelText, detailText) in featureLabels {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            label.textColor = .gray
            
            let detailLabel = UILabel()
            detailLabel.text = detailText
            detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            detailLabel.textColor = .black
            
            let featureStackView = UIStackView(arrangedSubviews: [label, detailLabel])
            featureStackView.axis = .horizontal
            featureStackView.alignment = .center
            featureStackView.spacing = 8
            
            featureViews.append(featureStackView)
        }
        
        // Create a stack view for all features and amenities
        let featuresStackView = UIStackView(arrangedSubviews: featureViews)
        featuresStackView.axis = .vertical
        featuresStackView.spacing = 10
        
        return featuresStackView
    }


    private let propertyLabel = UILabel()
    private let priceLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Post Detail Page"

        setupViews()
        setupCollectionView()
        displayPostDetails()
    }

    private func setupViews() {
        let propertyFeaturesView = propertyFeaturesView()
        let propertyInfoView = propertyInfoView()
        
        view.addSubview(imageCollectionView)
        view.addSubview(pageControl)
        view.addSubview(titleLabel)
        view.addSubview(locationLabel)
        view.addSubview(userInfoStackView)
        view.addSubview(propertyInfoLabel)
        view.addSubview(propertyFeatureLabel)
        view.addSubview(propertyLabel)
        view.addSubview(priceLabel)
        view.addSubview(propertyFeaturesView)
        view.addSubview(propertyInfoView)
        
        // Constraints for imageCollectionView
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(9.0 / 16.0)
        }

        // Constraints for pageControl
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        // Constraints for titleLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        // Constraints for locationLabel
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Constraints for userInfoStackView
        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }

        // Constraints for propertyInfoLabel
        propertyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        // Constraints for propertyInfoView
        propertyInfoView.snp.makeConstraints { make in
            make.top.equalTo(propertyInfoLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        // Constraints for propertyFeatureLabel
        propertyFeatureLabel.snp.makeConstraints { make in
            make.top.equalTo(propertyInfoView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        // Constraints for propertyFeaturesView
        propertyFeaturesView.snp.makeConstraints { make in
            make.top.equalTo(propertyFeatureLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Constraints for propertyLabel
        propertyLabel.snp.makeConstraints { make in
            make.top.equalTo(propertyFeaturesView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        // Constraints for priceLabel
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(propertyLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }



    private func setupCollectionView() {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        pageControl.numberOfPages = post?.images.count ?? 0
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
    }

    private func displayPostDetails() {
        guard let post = post else { return }
        imageCollectionView.reloadData()
        titleLabel.text = post.title
        locationLabel.text = post.location
        propertyLabel.text = post.propertyType
        priceLabel.text = "\(post.price) USD"
    }

    func configure(with post: RentPost) {
        self.post = post
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let imageUrl = post?.images[indexPath.item] {
            imageView.loadImage(from: imageUrl)
        }
        cell.contentView.addSubview(imageView)

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        if pageWidth > 0 {
            let pageIndex = round(scrollView.contentOffset.x / pageWidth)
            pageControl.currentPage = Int(pageIndex)
        } else {
            print("Invalid page width: \(pageWidth)")
        }
    }
}

