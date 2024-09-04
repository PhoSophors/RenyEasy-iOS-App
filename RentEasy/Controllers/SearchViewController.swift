import UIKit
import SnapKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    private var posts: [RentPost] = []
    private var filteredPost: [RentPost] = []
    private var users: [UserInfo] = []
    
    private var searchTextField: UITextField!
    
    // MARK: - UI Element
    
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
    
    private let searchPromptLabel: UIView = {
        let container = UIView()
        
        // Icon
        let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = ColorManagerUtilize.shared.forestGreen
        container.addSubview(iconImageView)
        
        // Text
        let textLabel = UILabel()
        textLabel.text = "Find post by title, description, \nlocation, and property."
        textLabel.textAlignment = .center
        textLabel.textColor = .gray
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 18)
        container.addSubview(textLabel)
        
        // Add constraints
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top)
            make.centerX.equalTo(container.snp.centerX)
            make.width.height.equalTo(100)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.centerX.equalTo(container.snp.centerX)
            make.bottom.equalTo(container.snp.bottom)
        }
        
        container.isHidden = true
        return container
    }()

    private let noPostLabel: UIView = {
        let container = UIView()
        
        // Icon
        let iconImageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = ColorManagerUtilize.shared.forestGreen
        container.addSubview(iconImageView)
        
        // Text
        let textLabel = UILabel()
        textLabel.text = "No post found."
        textLabel.textAlignment = .center
        textLabel.textColor = .gray
        textLabel.font = .systemFont(ofSize: 16, weight: .medium)
        container.addSubview(textLabel)
        
        // Add constraints
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top)
            make.centerX.equalTo(container.snp.centerX)
            make.width.height.equalTo(100)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.centerX.equalTo(container.snp.centerX)
            make.bottom.equalTo(container.snp.bottom)
        }
        
        container.isHidden = true
        return container
    }()

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupScrollView()
        setupSearchTextField()
        setupCollectionView()
        
        searchTextField.delegate = self
        scrollView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        performSearch(query: "")
        
        // Gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
        
    // MARK: - Private Helper Methods
    
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
        messageButton.layer.cornerRadius = 17.5
        messageButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        messageButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        
        // Set up the notification button
        let notificationImage = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysTemplate)
        let notificationButton = UIButton(type: .custom)
        notificationButton.setImage(notificationImage, for: .normal)
        notificationButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        notificationButton.layer.cornerRadius = 17.5
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
        searchTextField.backgroundColor = ColorManagerUtilize.shared.lightGray
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 0
        searchTextField.layer.borderColor = UIColor.clear.cgColor
        
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit

        let padding: CGFloat = 20
        let iconWidth: CGFloat = 20.0
        searchIcon.frame = CGRect(x: 0, y: 0, width: iconWidth, height: iconWidth)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: iconWidth + padding, height: iconWidth))
        paddingView.addSubview(searchIcon)
        searchIcon.center = CGPoint(x: paddingView.frame.size.width / 2, y: paddingView.frame.size.height / 2)
        
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always

        containerView.addSubview(searchTextField)

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.left.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).offset(-10)
            make.height.equalTo(40)
        }

        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }

    private func setupCollectionView() {
        containerView.addSubview(collectionView)
        containerView.addSubview(searchPromptLabel)
        containerView.addSubview(noPostLabel)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.left.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).offset(-10)
            make.bottom.equalTo(containerView).offset(-10)
            make.height.equalTo(0)
        }
       
        searchPromptLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(150)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        noPostLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(150)
            make.centerX.equalTo(containerView.snp.centerX)
        }
    }

    private func updateCollectionViewHeight() {
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
        view.layoutIfNeeded()
    }

    // MARK: - Search Handling Methods
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            self.posts = []
            self.filteredPost = []
            self.collectionView.reloadData()
            searchPromptLabel.isHidden = false
            noPostLabel.isHidden = true
            return
        }
        
        LoadingOverlay.shared.show(over: self.view)

        APICaller.searchPostsAndUsers(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.posts = response.data.posts
                    self.filteredPost = self.posts
                    self.collectionView.reloadData()
                    self.updateCollectionViewHeight()
                    self.searchPromptLabel.isHidden = true
                    self.noPostLabel.isHidden = !self.filteredPost.isEmpty
                    LoadingOverlay.shared.hide()

                case .failure(_):
                    self.posts = []
                    self.filteredPost = []
                    self.collectionView.reloadData()
                    self.updateCollectionViewHeight()
                    self.searchPromptLabel.isHidden = !self.filteredPost.isEmpty
                    self.noPostLabel.isHidden = true

                }
            }
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            filteredPost = []
            collectionView.reloadData()
            return
        }
        
        performSearch(query: searchText)
    }
   
    @objc private func messageButtonTapped() {
        let mainMessageViewController = MainMessageViewController()
        navigationController?.pushViewController(mainMessageViewController, animated: true)
    }
    
    @objc private func notificationButtonTapped() {
        let notificationViewController = NotificationViewController()
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !searchTextField.frame.contains(location) {
            view.endEditing(true)
        }
    }
    
}

// MARK: - Extensions for Delegates

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, AllRentCollectionViewCellDelegate, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPost.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRentCollectionViewCell.identifier, for: indexPath) as? AllRentCollectionViewCell else {
            fatalError("Cannot dequeue AllRentCollectionViewCell")
        }
        
        let post = filteredPost[indexPath.item]
        let firstImageURL = post.images.first
        cell.configure(with: firstImageURL, title: post.title, location: post.location, property: post.propertyType, price: post.price)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    // MARK: - AllRentCollectionViewCellDelegate
    func didTapHeartButton(on cell: AllRentCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = filteredPost[indexPath.item]
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = filteredPost[indexPath.item]
        let detailViewController = PostDetailViewController()

        detailViewController.configure(with: selectedPost)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
