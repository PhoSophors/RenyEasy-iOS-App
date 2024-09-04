import UIKit
import SnapKit

protocol AddUserViewControllerDelegate: AnyObject {
    func didSelectUser(_ user: UserInfo)
}

class AddUserViewController: UIViewController {
    weak var delegate: AddUserViewControllerDelegate?

    private var users: [UserInfo] = []
    private var filteredUsers: [UserInfo] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchTextField = UITextField()
    private var collectionView: UICollectionView!

    // MARK: - UI Element
    
    private let searchPromptLabel: UIView = {
        let container = UIView()
        
        // Icon
        let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = ColorManagerUtilize.shared.forestGreen
        container.addSubview(iconImageView)
        
        // Text
        let textLabel = UILabel()
        textLabel.text = "Please search user to send a message."
        textLabel.textAlignment = .center
        textLabel.textColor = .gray
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

    private let noUsersLabel: UIView = {
        let container = UIView()
        
        // Icon
        let iconImageView = UIImageView(image: UIImage(systemName: "person.crop.circle.badge.xmark"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = ColorManagerUtilize.shared.forestGreen
        container.addSubview(iconImageView)
        
        // Text
        let textLabel = UILabel()
        textLabel.text = "No user found."
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupScrollView()
        setupSearchTextField()
        setupCollectionView()
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchTextField.delegate = self
        
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        // Gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Fetch initial data
        performSearch(query: "")
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    // MARK: - Private Helper Methods
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }

    private func setupSearchTextField() {
        searchTextField.placeholder = "Search users..."
        searchTextField.borderStyle = .none
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.backgroundColor = ColorManagerUtilize.shared.white
        searchTextField.delegate = self
        
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

        contentView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.leading.equalTo(contentView.snp.leading).inset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
            make.height.equalTo(40)
        }
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "UserCollectionViewCell")
        contentView.addSubview(collectionView)
        contentView.addSubview(searchPromptLabel)
        contentView.addSubview(noUsersLabel)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).inset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
            make.bottom.equalTo(contentView.snp.bottom).inset(60)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }

        searchPromptLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(100)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        noUsersLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(100)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            self.users = []
            self.filteredUsers = []
            self.collectionView.reloadData()
            searchPromptLabel.isHidden = false
            noUsersLabel.isHidden = true
            return
        }
        
        LoadingOverlay.shared.show(over: self.view)

        APICaller.searchPostsAndUsers(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.users = response.data.users
                    self.filteredUsers = self.users
                    self.collectionView.reloadData()
                    self.searchPromptLabel.isHidden = true
                    self.noUsersLabel.isHidden = !self.filteredUsers.isEmpty
                    LoadingOverlay.shared.hide()
                    
                case .failure(_):
                    self.users = []
                    self.filteredUsers = []
                    self.collectionView.reloadData()
                    self.searchPromptLabel.isHidden = !self.filteredUsers.isEmpty
                    self.noUsersLabel.isHidden = true
                }
            }
        }
    }
    
    // MARK: - Action Methods

    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            filteredUsers = []
            collectionView.reloadData()
            return
        }
        
        performSearch(query: searchText)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.scrollIndicatorInsets.bottom = keyboardHeight
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !searchTextField.frame.contains(location) {
            view.endEditing(true)
        }
    }
    
    deinit {
        // Remove keyboard observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
}

// MARK: - Extensions for Delegates

extension AddUserViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        let user = filteredUsers[indexPath.item]
        cell.configure(with: user)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 32) / 2, height: 80)
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = filteredUsers[indexPath.item]
        delegate?.didSelectUser(selectedUser)
        dismiss(animated: true, completion: nil)
    }
}
