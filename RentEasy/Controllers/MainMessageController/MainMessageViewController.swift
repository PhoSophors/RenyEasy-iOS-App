import UIKit
import SnapKit
import SDWebImage

class MainMessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "No user messages yet."
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
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
        APICaller.fetchAllUserMessages() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.users = response.data.users
                    self?.fetchAllMessages()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func fetchAllMessages() {
        APICaller.fetchAllMessages() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.message = response.data.messages
                    self?.updateUI()
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
        if users.isEmpty {
            view.addSubview(userMessageLabel)
            userMessageLabel.snp.makeConstraints { make in
                make.center.equalTo(view)
                make.leading.trailing.equalTo(view).inset(20)
            }
            collectionView.isHidden = true
        } else {
            userMessageLabel.removeFromSuperview()
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }

    private func setupNavigationBar() {
        let addUserImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        let addUserButton = UIButton(type: .custom)
        addUserButton.setImage(addUserImage, for: .normal)
        addUserButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        addUserButton.layer.cornerRadius = 20
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
        let navController = UINavigationController(rootViewController: addUserVC)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListAllUserMessageCollectionViewCell", for: indexPath) as! ListAllUserMessageCollectionViewCell
        let user = users[indexPath.item]
        
        // Fetch the last message for the user
        let lastMessage = fetchLastMessage(for: user) ?? MessageModel(id: "", senderId: "", receiverId: "", content: "No message", status: "", timestamp: "")

        // Configure the cell with the user, message, senderId
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
        // Retrieve the selected user based on the clicked item
        let selectedUser = users[indexPath.item]
        
        // Create an instance of MessageViewController
        let messageVC = MessageViewController()
        
        // Pass the selected user to the message view controller
        messageVC.user = selectedUser
        
        // Push the message view controller onto the navigation stack
        navigationController?.pushViewController(messageVC, animated: true)
    }

    
    // MARK: - Error Handling

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

