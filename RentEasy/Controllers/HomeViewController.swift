import UIKit
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AllRentCollectionViewCellDelegate {

    private let heroCollectionView = HeroCollectionView()
    private let categoryCollectionViewCell = HomeCategoryCollectionViewCell()
    private let allRentCollectionViewCell = AllRentCollectionViewCell()
    private var vilaCollectionView: UICollectionView!
    private var condoCollectionView: UICollectionView!
    private var allRentCollectionView: UICollectionView!
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var vilaPosts: [RentPost] = []
    private var condoPosts: [RentPost] = []
    private var allPosts: [RentPost] = []
    private var favoriteViewModel = FavoriteViewModel()

    override func viewDidLoad() {
       super.viewDidLoad()
       view.backgroundColor = .white
       setupScrollView()
       setupHeroCollectionView()
       setupCategoryCollectionView()
       setupVilaCollectionView()
        setupCondoCollectionView()
       setupAllRentCollectionView()
       fetchPosts()
       favoriteViewModel.fetchFavorites()
       
       setupNavigationBar()
   }

    
    private func setupNavigationBar() {
        // Set up the left image view
        let leftImageView = UIImageView(image: UIImage(named: "AppIcon"))
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        
        // Customize border for the left image view
        leftImageView.layer.borderColor = ColorManagerUtilize.shared.forestGreen.cgColor
        leftImageView.layer.borderWidth = 0.5
        leftImageView.layer.cornerRadius = 17.5
        leftImageView.layer.masksToBounds = true
        
        // Set up the username label
        let usernameLabel = UILabel()
        usernameLabel.text = "RentEasy" 
        usernameLabel.textColor = ColorManagerUtilize.shared.forestGreen
        usernameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        // Create a container view for the image and username
        let leftContainerView = UIStackView(arrangedSubviews: [leftImageView, usernameLabel])
        leftContainerView.axis = .horizontal
        leftContainerView.spacing = 8
        leftContainerView.alignment = .center
        leftContainerView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftContainerView)
        
        // Set the left bar button item
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // Set up the message button
        let messageImage = UIImage(systemName: "message.fill")?.withRenderingMode(.alwaysTemplate)
        let messageButton = UIButton(type: .custom)
        messageButton.setImage(messageImage, for: .normal)
        messageButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        messageButton.layer.cornerRadius = 20
        messageButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        messageButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        
        // Set up the notification button
        let notificationImage = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysTemplate)
        let notificationButton = UIButton(type: .custom)
        notificationButton.setImage(notificationImage, for: .normal)
        notificationButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        notificationButton.layer.cornerRadius = 20
        notificationButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        
        // Create UIBarButtonItem instances
        let messageBarButtonItem = UIBarButtonItem(customView: messageButton)
        let notificationBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        // Set the right bar button items
        self.navigationItem.rightBarButtonItems = [messageBarButtonItem, notificationBarButtonItem]
        
        // Customize navigation bar appearance
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationController?.navigationBar.isTranslucent = false
    }


    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    private func setupHeroCollectionView() {
        contentView.addSubview(heroCollectionView)
        heroCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    private func setupCategoryCollectionView() {
        contentView.addSubview(categoryCollectionViewCell)
        categoryCollectionViewCell.snp.makeConstraints { make in
            make.top.equalTo(heroCollectionView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
    }

    private func vilaLabelView() -> UIStackView {
        let label = UILabel()
        label.text = "VILLA"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .darkGray
        
        let seeMoreLabel = UILabel()
        seeMoreLabel.text = "SEE MORE"
        seeMoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        seeMoreLabel.textColor = ColorManagerUtilize.shared.forestGreen
        
        let stackView = UIStackView(arrangedSubviews: [label, seeMoreLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionViewCell.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(30)
        }
        
        return stackView
    }

    private func setupVilaCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.6, height: 270) // Adjust width to 60% of screen width
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        vilaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vilaCollectionView.delegate = self
        vilaCollectionView.dataSource = self
        vilaCollectionView.backgroundColor = .white
        vilaCollectionView.showsHorizontalScrollIndicator = false
        vilaCollectionView.register(AllRentCollectionViewCell.self, forCellWithReuseIdentifier: AllRentCollectionViewCell.identifier)

        contentView.addSubview(vilaCollectionView)
        let labelView = vilaLabelView()

        vilaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(270)
        }
    }

    private func condoLabelView() -> UIStackView {
        let label = UILabel()
        label.text = "CONDO"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .darkGray
        
        let seeMoreLabel = UILabel()
        seeMoreLabel.text = "SEE MORE"
        seeMoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        seeMoreLabel.textColor = ColorManagerUtilize.shared.forestGreen
        seeMoreLabel.isUserInteractionEnabled = true
        
        let stackView = UIStackView(arrangedSubviews: [label, seeMoreLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(vilaCollectionView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(30)
        }
        
        // Add tap gesture recognizer to the "See more" label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreTapped))
        seeMoreLabel.addGestureRecognizer(tapGesture)
        
        return stackView
    }
    
    private func setupCondoCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.5, height: 250)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        condoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        condoCollectionView.delegate = self
        condoCollectionView.dataSource = self
        condoCollectionView.backgroundColor = .white
        condoCollectionView.showsVerticalScrollIndicator = false
        condoCollectionView.register(AllRentCollectionViewCell.self, forCellWithReuseIdentifier: AllRentCollectionViewCell.identifier)

        contentView.addSubview(condoCollectionView)
        let labelView = condoLabelView()

        condoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(250)
        }
    }
    
    private func allRentLabelView() -> UIStackView {
        let label = UILabel()
        label.text = "ALL"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .darkGray
        
        let seeMoreLabel = UILabel()
        seeMoreLabel.text = "SEE MORE"
        seeMoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        seeMoreLabel.textColor = ColorManagerUtilize.shared.forestGreen
        seeMoreLabel.isUserInteractionEnabled = true
        
        let stackView = UIStackView(arrangedSubviews: [label, seeMoreLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(condoCollectionView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(30)
        }
        
        // Add tap gesture recognizer to the "See more" label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreTapped))
        seeMoreLabel.addGestureRecognizer(tapGesture)
        
        return stackView
    }
    
    private func setupAllRentCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.5, height: 250)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        allRentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        allRentCollectionView.delegate = self
        allRentCollectionView.dataSource = self
        allRentCollectionView.backgroundColor = .white
        allRentCollectionView.showsVerticalScrollIndicator = false
        allRentCollectionView.register(AllRentCollectionViewCell.self, forCellWithReuseIdentifier: AllRentCollectionViewCell.identifier)

        contentView.addSubview(allRentCollectionView)
        let labelView = allRentLabelView()

        allRentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.height.equalTo(250)
        }
    }
    
    private func fetchPosts() {
        // Fetch posts by property type
        APICaller.fetchAllPostByProperty(propertytype: "villa") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostByProperty):
                    // Ensure data.posts is of type [RentPost]
                    self?.vilaPosts = allPostByProperty.data.posts
                    self?.vilaCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch villa posts: \(error)")
                }
            }
        }
        
        APICaller.fetchAllPostByProperty(propertytype: "condo") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostByProperty):
                    // Ensure data.posts is of type [RentPost]
                    self?.condoPosts = allPostByProperty.data.posts
                    self?.condoCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch condo posts: \(error)")
                }
            }
        }
        
        // Fetch all posts
        APICaller.fetchAllPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostsResponse):
                    // Ensure data.posts is of type [RentPost]
                    self?.allPosts = allPostsResponse.data.posts
                    self?.allRentCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch all posts: \(error)")
                }
            }
        }
    }


    // MARK: - UICollectionViewDataSource for Vila
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vilaCollectionView {
            return min(vilaPosts.count, 8)
        } else if collectionView == condoCollectionView {
            return min(condoPosts.count, 8)
        } else {
            return min(allPosts.count, 8)
        }
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == vilaCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRentCollectionViewCell.identifier, for: indexPath) as? AllRentCollectionViewCell else {
                return UICollectionViewCell()
            }

            let post = vilaPosts[indexPath.item]
            let imageUrl = post.images.first
            let isFavorite = favoriteViewModel.isFavorite(postId: post.id)

            cell.configure(with: imageUrl, title: post.title, location: post.location, property: post.propertyType, price: post.price)
            cell.isFavorite = isFavorite
            cell.delegate = self

            return cell
        } else if collectionView == condoCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRentCollectionViewCell.identifier, for: indexPath) as? AllRentCollectionViewCell else {
                return UICollectionViewCell()
            }

            let post = condoPosts[indexPath.item]
            let imageUrl = post.images.first
            let isFavorite = favoriteViewModel.isFavorite(postId: post.id)

            cell.configure(with: imageUrl, title: post.title, location: post.location, property: post.propertyType, price: post.price)
            cell.isFavorite = isFavorite
            cell.delegate = self

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRentCollectionViewCell.identifier, for: indexPath) as? AllRentCollectionViewCell else {
                return UICollectionViewCell()
            }

            let post = allPosts[indexPath.item]
            let imageUrl = post.images.first
            let isFavorite = favoriteViewModel.isFavorite(postId: post.id)

            cell.configure(with: imageUrl, title: post.title, location: post.location, property: post.propertyType, price: post.price)
            cell.isFavorite = isFavorite
            cell.delegate = self

            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = PostDetailViewController()
        
        if collectionView == vilaCollectionView {
            let selectedPost = vilaPosts[indexPath.item]
            detailViewController.configure(with: selectedPost)
        } else if collectionView == condoCollectionView {
            let selectedPost = condoPosts[indexPath.item]
            detailViewController.configure(with: selectedPost)
        } else {
            let selectedPost = allPosts[indexPath.item]
            detailViewController.configure(with: selectedPost)
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    

    @objc private func heartButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? AllRentCollectionViewCell,
              let indexPath = vilaCollectionView.indexPath(for: cell) else {
            print("Error: Unable to determine indexPath for cell")
            return
        }

        let postId = vilaPosts[indexPath.item].id
        let newFavoriteStatus = !cell.isFavorite

        if newFavoriteStatus {
            favoriteViewModel.addFavorite(postId: postId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.vilaPosts[indexPath.item].isFavorite = true
                        self?.vilaCollectionView.reloadItems(at: [indexPath])
                    case .failure(let error):
                        print("Failed to add favorite: \(error)")
                    }
                }
            }
        } else {
            favoriteViewModel.removeFavorite(postId: postId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.vilaPosts[indexPath.item].isFavorite = false
                        self?.vilaCollectionView.reloadItems(at: [indexPath])
                    case .failure(let error):
                        print("Failed to remove favorite: \(error)")
                    }
                }
            }
        }
    }

    func didTapHeartButton(on cell: AllRentCollectionViewCell) {
        guard let indexPath = vilaCollectionView.indexPath(for: cell) else {
            print("Error: Unable to determine indexPath for cell")
            return
        }

        let postId = vilaPosts[indexPath.item].id
        let isCurrentlyFavorite = favoriteViewModel.isFavorite(postId: postId)
        let newFavoriteStatus = !isCurrentlyFavorite

        if newFavoriteStatus {
            // Add to favorites
            favoriteViewModel.addFavorite(postId: postId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        print("Added Post to Favorites successfully: \(message)")
                        cell.isFavorite = true
                        self?.vilaPosts[indexPath.item].isFavorite = true
                        self?.vilaCollectionView.reloadItems(at: [indexPath])
                    case .failure(let error):
                        print("Failed to add favorite: \(error)")
                        cell.isFavorite = false
                    }
                }
            }
        } else {
            // Remove from favorites
            favoriteViewModel.removeFavorite(postId: postId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        print("Removed Post from Favorites successfully: \(message)")
                        cell.isFavorite = false
                        self?.vilaPosts[indexPath.item].isFavorite = false
                        self?.vilaCollectionView.reloadItems(at: [indexPath])
                    case .failure(let error):
                        print("Failed to remove favorite: \(error)")
                        cell.isFavorite = true
                    }
                }
            }
        }
    }

    // MARK: - Action
    
    @objc private func seeMoreTapped() {
        let allPostViewController = AllPostViewController()
        navigationController?.pushViewController(allPostViewController, animated: true)
        
        print("See more button tapped..!")
    }

    @objc private func messageButtonTapped() {
        let mainMessageViewController = MainMessageViewController()
        navigationController?.pushViewController(mainMessageViewController, animated: true)
    }
    
    @objc private func notificationButtonTapped() {
        let notificationViewController = NotificationViewController()
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
}
