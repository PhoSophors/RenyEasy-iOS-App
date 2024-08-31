import UIKit
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AllRentCollectionViewCellDelegate, HomeCategoryCollectionViewCellDelegate {

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
    var userInfo: UserInfo?

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
    
    // MARK: - setupNavigationBar
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
    
    // MARK: - Scroll View
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
    
    // MARK: - Setup Hero Display
    private func setupHeroCollectionView() {
        contentView.addSubview(heroCollectionView)
        heroCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    // MARK: - Setup Category
    private func setupCategoryCollectionView() {
        categoryCollectionViewCell.delegate = self
        view.addSubview(categoryCollectionViewCell)
        
        contentView.addSubview(categoryCollectionViewCell)
        categoryCollectionViewCell.snp.makeConstraints { make in
            make.top.equalTo(heroCollectionView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
    }

    func didSelectCategory(_ category: String) {
        let allPostViewController = AllPostViewController(propertyType: category)
        navigationController?.pushViewController(allPostViewController, animated: true)
    }
    
    // MARK: - Villa View
    private func vilaLabelView() -> UIStackView {
        let label = UILabel()
        label.text = "VILLA"
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
            make.top.equalTo(categoryCollectionViewCell.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(30)
        }
        
        // Add tap gesture recognizer to the "See more" label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreVilaTapped))
        seeMoreLabel.addGestureRecognizer(tapGesture)
        
        return stackView
    }

    private func setupVilaCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.6, height: 270) // Adjust width to 60% of screen width
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

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

    // MARK: - Condo View
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreCondoTapped))
        seeMoreLabel.addGestureRecognizer(tapGesture)
        
        return stackView
    }
    
    private func setupCondoCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.5, height: 250)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

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
    
    // MARK: - All View
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreAllRentTapped))
        seeMoreLabel.addGestureRecognizer(tapGesture)
        
        return stackView
    }
    
    private func setupAllRentCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.5, height: 250)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

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
    
    // MARK: - Fetch Post
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
        
//        APICaller.getUserInfo(userId: userId) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let user):
//                    self?.userInfo = user
//                    // print("Fetched user info: \(user)") // Debugging line
//                case .failure(let error):
//                    print("Failed to fetch user info: \(error)")
//                }
//            }
//        }
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
    
    // MARK: - Action
    
    @objc private func heartButtonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? AllRentCollectionViewCell {
            didTapHeartButton(on: cell)
        } else {
            print("Error: Unable to determine indexPath for cell")
        }
    }

    func didTapHeartButton(on cell: AllRentCollectionViewCell) {
        guard let indexPath = findIndexPath(for: cell) else {
            print("Error: Unable to determine indexPath for cell")
            return
        }

        guard let userInfo = userInfo else {
            print("Error: userInfo is not available")
            return
        }

        let (postId, collectionView) = postIdAndCollectionView(for: cell, indexPath: indexPath)
        
        let isCurrentlyFavorite = userInfo.favorites.contains(postId)
        let newFavoriteStatus = !isCurrentlyFavorite

        if newFavoriteStatus {
            favoriteViewModel.addFavorite(postId: postId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        print("Added Post to Favorites successfully: \(message)")
                        cell.isFavorite = true
                        self?.updatePosts(postId: postId, isFavorite: true)
                        collectionView.reloadItems(at: [indexPath])
                    case .failure(let error):
                        print("Failed to add favorite: \(error)")
                    }
                }
            }
        } else {
            favoriteViewModel.removeFavorite(postId: postId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        print("Removed Post from Favorites successfully: \(message)")
                        cell.isFavorite = false
                        self?.updatePosts(postId: postId, isFavorite: false)
                        collectionView.reloadItems(at: [indexPath])
                    case .failure(let error):
                        print("Failed to remove favorite: \(error)")
                    }
                }
            }
        }
    }

    private func findIndexPath(for cell: AllRentCollectionViewCell) -> IndexPath? {
        return [vilaCollectionView, condoCollectionView, allRentCollectionView]
            .compactMap { $0.indexPath(for: cell) }
            .first
    }

    private func postIdAndCollectionView(for cell: AllRentCollectionViewCell, indexPath: IndexPath) -> (postId: String, collectionView: UICollectionView) {
        if let indexPath = vilaCollectionView.indexPath(for: cell) {
            return (vilaPosts[indexPath.item].id, vilaCollectionView)
        } else if let indexPath = condoCollectionView.indexPath(for: cell) {
            return (condoPosts[indexPath.item].id, condoCollectionView)
        } else if let indexPath = allRentCollectionView.indexPath(for: cell) {
            return (allPosts[indexPath.item].id, allRentCollectionView)
        } else {
            fatalError("Error: Cell is not in any known collection view")
        }
    }
    
    private func updatePosts(postId: String, isFavorite: Bool) {
        for (index, post) in vilaPosts.enumerated() where post.id == postId {
            vilaPosts[index].isFavorite = isFavorite
        }
        for (index, post) in condoPosts.enumerated() where post.id == postId {
            condoPosts[index].isFavorite = isFavorite
        }
        for (index, post) in allPosts.enumerated() where post.id == postId {
            allPosts[index].isFavorite = isFavorite
        }
    }

    @objc private func seeMoreVilaTapped() {
        let allPostViewController = AllPostViewController(propertyType: "villa")
        navigationController?.pushViewController(allPostViewController, animated: true)
    }
    
    @objc private func seeMoreCondoTapped() {
        let allPostViewController = AllPostViewController(propertyType: "condo")
        navigationController?.pushViewController(allPostViewController, animated: true)
    }

    @objc private func seeMoreAllRentTapped() {
        let allPostViewController = AllPostViewController(propertyType: nil)
        navigationController?.pushViewController(allPostViewController, animated: true)
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
