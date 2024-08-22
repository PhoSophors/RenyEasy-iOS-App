import UIKit
import SnapKit

class SearchViewController: UIViewController {

    private var searchTextField: UITextField!
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(AllRentCollectionViewCell.self, forCellWithReuseIdentifier: AllRentCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found"
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .yellow
        return label
    }()
    
    private var posts: [RentPost] = []
    private var users: [UserInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManagerUtilize.shared.white
        setupNavigationBar()
        
        setupScrollView()
        setupSearchTextField()
        setupCollectionView()
        setupNoResultsLabel()
        
        noResultsLabel.isHidden = false
        view.layoutIfNeeded()
    }
    
    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        // Set up the left label
        let leftLabel = UILabel()
        leftLabel.text = "Search"
        leftLabel.font = UIFont.boldSystemFont(ofSize: 22)
        leftLabel.textColor = ColorManagerUtilize.shared.forestGreen
        leftLabel.textAlignment = .center
        
        // Create a container view for the label
        let leftContainerView = UIStackView(arrangedSubviews: [leftLabel])
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

        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }

    private func setupSearchTextField() {
        searchTextField = UITextField()
        searchTextField.placeholder = "Search..."
        searchTextField.borderStyle = .none
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.backgroundColor = ColorManagerUtilize.shared.white
        searchTextField.delegate = self
        
        // Create a search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray // Set color for the icon
        searchIcon.contentMode = .scaleAspectFit

        // Set padding
        let padding: CGFloat = 20
        let iconWidth: CGFloat = 20.0
        searchIcon.frame = CGRect(x: 0, y: 0, width: iconWidth, height: iconWidth)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: iconWidth + padding, height: iconWidth))
        paddingView.addSubview(searchIcon)
        searchIcon.center = CGPoint(x: paddingView.frame.size.width / 2, y: paddingView.frame.size.height / 2)
        
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always

        // Set corner radius
        searchTextField.layer.cornerRadius = 20
        searchTextField.layer.borderWidth = 1
        searchTextField.backgroundColor = nil
        searchTextField.layer.borderColor = ColorManagerUtilize.shared.deepCharcoal.cgColor

        containerView.addSubview(searchTextField)

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.left.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).offset(-10)
            make.height.equalTo(40)
        }
    }

    private func setupCollectionView() {
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.left.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).offset(-10)
            make.bottom.equalTo(containerView).offset(-10)
            make.height.equalTo(0)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
    }
    
    private func setupNoResultsLabel() {
        containerView.addSubview(noResultsLabel)
        noResultsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.bottom.equalTo(containerView.snp.bottom).offset(-20)
        }
        noResultsLabel.isHidden = true
    }

    private func updateCollectionViewHeight() {
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
        view.layoutIfNeeded()
    }

    private func updateNoResultsLabelVisibility() {
        let shouldHideLabel = (posts.isEmpty && users.isEmpty)
        noResultsLabel.isHidden = shouldHideLabel
        print("NoResultsLabel is hidden: \(shouldHideLabel)") // Debugging statement
    }


    private func performSearch(query: String) {
        print("Performing search with query: \(query)") // Debugging statement

        APICaller.searchPostsAndUsers(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Search successful: \(response)") // Debugging statement
                    self.posts = response.data.posts
                    self.users = response.data.users
                    self.collectionView.reloadData()
                    self.updateCollectionViewHeight()
                    self.updateNoResultsLabelVisibility()
                case .failure(let error):
                    print("Failed to search: \(error)") // Debugging statement
                    self.posts = []
                    self.users = []
                    self.collectionView.reloadData()
                    self.updateCollectionViewHeight()
                    self.updateNoResultsLabelVisibility()
                    
                    // Correct print statement
                    print("Posts after failure: \(self.posts)")
                }
            }
        }
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

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRentCollectionViewCell.identifier, for: indexPath) as? AllRentCollectionViewCell else {
            fatalError("Cannot dequeue AllRentCollectionViewCell")
        }
        
        let post = posts[indexPath.item]
        let firstImageURL = post.images.first
        cell.configure(with: firstImageURL, title: post.title, location: post.location, property: post.propertyType, price: post.price)
        cell.isFavorite = post.isFavorite
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty else {
            return true
        }
        
        textField.resignFirstResponder()
        performSearch(query: query)
        
        return true
    }
}

// MARK: - AllRentCollectionViewCellDelegate
extension SearchViewController: AllRentCollectionViewCellDelegate {
    func didTapHeartButton(on cell: AllRentCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = posts[indexPath.item]
        post.isFavorite.toggle()
        cell.isFavorite = post.isFavorite
    }
}
