import UIKit
import SnapKit
import SDWebImage

class MainMessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddUserViewControllerDelegate {
    
    private var users: [UserInfo] = []
    private var message: [MessageModel] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let userMessageLabel: UIView = {
        let container = UIView()
        container.backgroundColor = .white // Ensure background color is set to be visible

        // Icon
        let iconImageView = UIImageView(image: UIImage(systemName: "bubble.left.and.bubble.right.fill"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = ColorManagerUtilize.shared.forestGreen
        container.addSubview(iconImageView)

        // Text
        let textLabel = UILabel()
        textLabel.text = "No user message yet."
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

        container.isHidden = true // Set visibility to false initially
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
        fetchAllUserMessages()
    }
    
    private func fetchAllUserMessages() {
        LoadingOverlay.shared.show(over: self.view)
        APICaller.fetchAllUserMessages() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.users = response.data.users
                    LoadingOverlay.shared.hide()
                    self?.fetchAllMessages()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func fetchAllMessages() {
        LoadingOverlay.shared.show(over: self.view)
        APICaller.fetchAllMessages() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.message = response.data.messages
                    self?.updateUI()
                    LoadingOverlay.shared.hide()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }

    private func fetchLastMessage(for user: UserInfo) -> MessageModel? {
        // Filter messages where receiverId matches user.id
        let filteredMessages = message.filter { $0.receiverId == user.id || $0.senderId == user.id }
        // Sort messages by timestamp and get the most recent one
        let lastMessage = filteredMessages.sorted { $0.timestamp > $1.timestamp }.first
        
        return lastMessage
    }

    private func updateUI() {
        print("Updating UI: Users count is \(users.count)")
        if users.isEmpty {
            print("Showing userMessageLabel")
            userMessageLabel.isHidden = false
            view.addSubview(userMessageLabel)
            userMessageLabel.snp.makeConstraints { make in
                make.center.equalTo(view)
                make.leading.trailing.equalTo(view).inset(20)
            }
            collectionView.isHidden = true
        } else {
            print("Hiding userMessageLabel")
            userMessageLabel.isHidden = true
            userMessageLabel.removeFromSuperview()
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        let addUserImage = UIImage(systemName: "person.crop.circle.fill.badge.plus")?.withRenderingMode(.alwaysTemplate)
        let addUserButton = UIButton(type: .custom)
        addUserButton.setImage(addUserImage, for: .normal)
        addUserButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        addUserButton.layer.cornerRadius = 17.5
        addUserButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        addUserButton.addTarget(self, action: #selector(addUserButtonTapped), for: .touchUpInside)
        
        let addUserBarButtonItem = UIBarButtonItem(customView: addUserButton)
        self.navigationItem.rightBarButtonItems = [addUserBarButtonItem]
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationController?.navigationBar.isTranslucent = false
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListAllUserMessageCollectionViewCell.self, forCellWithReuseIdentifier: "ListAllUserMessageCollectionViewCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }

    @objc private func addUserButtonTapped() {
       let addUserVC = AddUserViewController()
       // Set the delegate to self
       addUserVC.delegate = self
       let navController = UINavigationController(rootViewController: addUserVC)
       present(navController, animated: true, completion: nil)
    }

    // MARK: - AddUserViewControllerDelegate

    func didSelectUser(_ user: UserInfo) {
       let messageViewController = MessageViewController()
       messageViewController.user = user

       // Hide the tab bar when pushing the message view controller
       messageViewController.hidesBottomBarWhenPushed = true

       navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListAllUserMessageCollectionViewCell", for: indexPath) as! ListAllUserMessageCollectionViewCell
        let user = users[indexPath.item]
        let lastMessage = fetchLastMessage(for: user) ?? MessageModel(id: "", senderId: "", receiverId: "", content: "No message", status: "", timestamp: "")
        
        cell.configure(with: user, message: lastMessage)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 70)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.item]
        let messageVC = MessageViewController()
        messageVC.user = selectedUser

        // Hide the bottom tab bar when pushing the message view controller
        messageVC.hidesBottomBarWhenPushed = true

        // Push the view controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(messageVC, animated: true)
        } else {
            // If not embedded in UINavigationController, handle appropriately
            let navController = UINavigationController(rootViewController: messageVC)
            self.present(navController, animated: true, completion: nil)
        }
    }

    
    // MARK: - Error Handling

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
