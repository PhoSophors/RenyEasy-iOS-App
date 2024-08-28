import UIKit
import SnapKit

class PostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var postID: String?
    
    private var post: RentPost?
    private let pageControl = UIPageControl()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userInfoStackView = UIStackView()
    
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
        label.textColor = ColorManagerUtilize.shared.forestGreen
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManagerUtilize.shared.deepCharcoal
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private func configureUserInfoStackView() {
        // Clear any existing arranged subviews from userInfoStackView
        userInfoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard let firstUser = post?.user.first else {
            // Handle case where user array is empty or nil
            return
        }
        
        let userImageView = UIImageView()
        userImageView.image = UIImage(systemName: "person.circle.fill")
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 20
        userImageView.backgroundColor = ColorManagerUtilize.shared.white
        userImageView.tintColor = ColorManagerUtilize.shared.deepCharcoal
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        // Use the profile photo URL directly
        if !firstUser.profilePhoto.isEmpty {
            userImageView.loadImage(from: firstUser.profilePhoto) { image in
                if let image = image {
                    // Successfully loaded image
                    userImageView.image = image
                } else {
                    // Handle image loading failure
                    print("Failed to load image")
                }
            }
        } else {
            print("No profile photo URL available")
        }
        
        let nameLabel = UILabel()
        nameLabel.text = firstUser.username
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = ColorManagerUtilize.shared.deepCharcoal

        // Display role information
        let roleLabel = UILabel()
        if let firstRole = firstUser.roles.first {
            roleLabel.text = firstRole.name // Assuming 'name' is the field you want to display
        } else {
            roleLabel.text = "No role assigned"
        }
        roleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        roleLabel.textColor = ColorManagerUtilize.shared.forestGreen

        let labelStackView = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 2

        let phoneButton = UIButton(type: .system)
        phoneButton.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        phoneButton.tintColor = ColorManagerUtilize.shared.deepCharcoal
        phoneButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        phoneButton.layer.cornerRadius = 20
        phoneButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        let messageButton = UIButton(type: .system)
        messageButton.setImage(UIImage(systemName: "message.fill"), for: .normal)
        messageButton.tintColor = ColorManagerUtilize.shared.deepCharcoal
        messageButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        messageButton.layer.cornerRadius = 20
        messageButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        let stackView = UIStackView(arrangedSubviews: [userImageView, labelStackView, messageButton, phoneButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.backgroundColor = ColorManagerUtilize.shared.lightGray
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.clipsToBounds = true
        
        userInfoStackView.addArrangedSubview(stackView)
    }

    private let propertyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Property Information"
        label.textColor = ColorManagerUtilize.shared.deepCharcoal
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private func propertyInfoView() -> UIView {
        var lastUpdateText = "N/A"
        var createdDateText = "N/A"
        
        if let createdAtString = post?.createdAt {
            print("createAt: \(createdAtString)")  // Debug: Check the createdAt string
            if let createdAtDate = DateUtility.dateFromISO8601String(createdAtString) {
                // Debug: Print current date and createdAtDate for comparison
                let currentDate = Date()
                print("Current date: \(currentDate)")
                print("Post created date: \(createdAtDate)")
                
                lastUpdateText = DateUtility.timeAgoSinceDate(createdAtDate, currentDate: currentDate)
                createdDateText = DateUtility.formattedDateString(from: createdAtDate)
                print("lastUpdateText: \(lastUpdateText)")
                print("createdDateText: \(createdDateText)")
            } else {
                print("Failed to convert date from string: \(createdAtString)")
            }
        } else {
            print("post?.createdAt is nil")
        }
        
        let featureLabels: [(String, String)] = [
            ("• Type:", post?.propertyType ?? "N/A"),
            ("• Last Update:", lastUpdateText),
            ("• Created Date:", createdDateText)
        ]
        
        var featureViews: [UIStackView] = []
        
        for (labelText, detailText) in featureLabels {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .gray
            
            let detailLabel = UILabel()
            detailLabel.text = detailText
            detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            detailLabel.textColor = ColorManagerUtilize.shared.forestGreen
            
            let featureStackView = UIStackView(arrangedSubviews: [label, detailLabel])
            featureStackView.axis = .horizontal
            featureStackView.alignment = .center
            featureStackView.spacing = 8
            
            featureViews.append(featureStackView)
        }
        
        let featuresStackView = UIStackView(arrangedSubviews: featureViews)
        featuresStackView.axis = .vertical
        featuresStackView.spacing = 10

        let featuresContainerView = UIView()
        featuresContainerView.backgroundColor = ColorManagerUtilize.shared.lightGray
        featuresContainerView.layer.cornerRadius = 5
        
        featuresContainerView.addSubview(featuresStackView)
        featuresStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        return featuresContainerView
    }

    private let propertyFeatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Property Feature and Amenities"
        label.textColor = ColorManagerUtilize.shared.deepCharcoal
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
 
    private func propertyFeaturesView() -> UIView {
        let featureLabels: [(String, String)] = [
           ("• Location:", post?.location ?? "N/A"),
           ("• Asking price:", "$\(post?.price ?? 0) /Month"),
           ("• Bedrooms:", "\(post?.bedrooms ?? 0)"),
           ("• Bathrooms:", "\(post?.bathrooms ?? 0)"),
           ("• Contact:", post?.contact ?? "N/A")
       ]
      
        var featureViews: [UIStackView] = []
        
        for (labelText, detailText) in featureLabels {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .gray
            
            let detailLabel = UILabel()
            detailLabel.text = detailText
            detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            detailLabel.textColor = ColorManagerUtilize.shared.forestGreen
            
            let featureStackView = UIStackView(arrangedSubviews: [label, detailLabel])
            featureStackView.axis = .horizontal
            featureStackView.alignment = .center
            featureStackView.spacing = 8
            
            featureViews.append(featureStackView)
        }
        
        let featuresStackView = UIStackView(arrangedSubviews: featureViews)
        featuresStackView.axis = .vertical
        featuresStackView.spacing = 10
        
        let featuresContainerView = UIView()
        featuresContainerView.backgroundColor = ColorManagerUtilize.shared.lightGray
        featuresContainerView.layer.cornerRadius = 5
        
        featuresContainerView.addSubview(featuresStackView)
        featuresStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        return featuresContainerView
    }
    
    private func descriptionView() -> UIView {
        // Create a container view for the description
        let descriptionContainerView = UIView()
        descriptionContainerView.backgroundColor = ColorManagerUtilize.shared.lightGray
        descriptionContainerView.layer.cornerRadius = 5
        
        // Create the description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = post?.content ?? "No description available"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = ColorManagerUtilize.shared.deepCharcoal
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        descriptionContainerView.addSubview(descriptionLabel)
        
        // Use SnapKit to set constraints
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        return descriptionContainerView
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Post Details"

        setupViews()
        setupCollectionView()
        displayPostDetails()
        
        // Create a UIBarButtonItem with the desired image
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.right.fill"),
            style: .plain,
            target: self,
            action: #selector(shareBarButtonTapped)
        )

        // Add the UIBarButtonItem to the right side of the navigation bar
        self.navigationItem.rightBarButtonItem = rightButton
    }

    private func setupViews() {
        let propertyFeaturesView = propertyFeaturesView()
        let propertyInfoView = propertyInfoView()
        let descriptionView = descriptionView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(userInfoStackView)
        contentView.addSubview(propertyInfoLabel)
        contentView.addSubview(propertyFeatureLabel)
        contentView.addSubview(propertyFeaturesView)
        contentView.addSubview(propertyInfoView)
        contentView.addSubview(descriptionView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(9.0 / 16.0)
        }

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(60)
        }

        propertyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        propertyInfoView.snp.makeConstraints { make in
            make.top.equalTo(propertyInfoLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        propertyFeatureLabel.snp.makeConstraints { make in
            make.top.equalTo(propertyInfoView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        propertyFeaturesView.snp.makeConstraints { make in
            make.top.equalTo(propertyFeatureLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(descriptionView.snp.top).offset(-10) // Updated
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(propertyFeaturesView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
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
        configureUserInfoStackView()
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageUrl = post?.images[indexPath.item] else { return }
        
        // Load the image
        let imageView = UIImageView()
        imageView.loadImage(from: imageUrl) { image in
            if let image = image {
                // Present PhotoDetailViewController modally
                let photoDetailViewController = PhotoDetailViewController(image: image)
                photoDetailViewController.modalPresentationStyle = .fullScreen 
                self.present(photoDetailViewController, animated: true, completion: nil)
            } else {
                // Handle image loading failure
                print("Failed to load image for photo detail view")
            }
        }
    }



    
    // MARK: - Action
    
    @objc private func shareBarButtonTapped() {
        let sharePostViewController = SharePostViewController()
//        sharePostViewController.modalPresentationStyle = .fullScreen
        self.present(sharePostViewController, animated: true, completion: nil)
    }
}

