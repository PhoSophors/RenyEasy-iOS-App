import UIKit
import SnapKit

class MessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var user: UserInfo?
    private var messages: [MessageModel] = []
    private var sendNewMessage: SendMessageData?
    private var receiverId: String?
    private let currentUserViewModel = UserViewModel()

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

    private let noMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "No messages yet."
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let messageInputView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManagerUtilize.shared.lightGray
        view.layer.cornerRadius = 10
        return view
    }()

    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a message..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
        button.tintColor = UIColor.systemBlue
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        guard let user = user else {
            print("User data is not available")
            return
        }
        
        let rightImageView = UIImageView()
          
        if !user.profilePhoto.isEmpty, let url = URL(string: user.profilePhoto) {
          rightImageView.sd_setImage(with: url, completed: nil)
        } else {
          rightImageView.image = UIImage(systemName: "person.circle.fill")
        }
        // Customize border for the right image view
        rightImageView.layer.borderColor = ColorManagerUtilize.shared.forestGreen.cgColor
        rightImageView.layer.borderWidth = 0.5
        rightImageView.layer.cornerRadius = 17.5
        rightImageView.layer.masksToBounds = true
        
        rightImageView.snp.makeConstraints { make in
           make.width.height.equalTo(35)
       }
        
        // Set up the username label
        let usernameLabel = UILabel()
        usernameLabel.text = user.username
        usernameLabel.textColor = ColorManagerUtilize.shared.forestGreen
        usernameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        // Create a container view for the username and image
        let rightContainerView = UIStackView(arrangedSubviews: [usernameLabel, rightImageView])
        rightContainerView.axis = .horizontal
        rightContainerView.spacing = 8
        rightContainerView.alignment = .center
        rightContainerView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightContainerView)
        
        // Set the right bar button item
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

        // Customize navigation bar appearance
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationBar()
        setupCollectionView()
        setupInputView()
        setupLayout()
      
        setupKeyboardObservers()

        if let userId = user?.id {
            receiverId = userId
            fetchMessages(for: userId)
            print("receiverId: \(userId)")
        }
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }


    private func fetchMessages(for userId: String) {
        LoadingOverlay.shared.show(over: self.view)
        APICaller.fetchAllMessages { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    LoadingOverlay.shared.hide()
                    self?.messages = response.data.messages.filter {
                        $0.receiverId == userId || $0.senderId == userId
                    }
                    self?.updateUI()

                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }

    private func updateUI() {
        if messages.isEmpty {
            view.addSubview(noMessageLabel)
            noMessageLabel.snp.makeConstraints { make in
                make.center.equalTo(view)
                make.leading.trailing.equalTo(view).inset(20)
            }
            collectionView.isHidden = true
        } else {
            noMessageLabel.removeFromSuperview()
            collectionView.isHidden = false
            collectionView.reloadData()
            scrollToBottom()
        }
    }

    private func scrollToBottom() {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        if numberOfItems > 0 {
            let lastIndexPath = IndexPath(item: numberOfItems - 1, section: 0)
            collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
        }
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCollectionViewCell")
        view.addSubview(collectionView)
    }

    private func setupInputView() {
        view.addSubview(messageInputView)
        messageInputView.addSubview(messageTextField)
        messageInputView.addSubview(sendButton)

        messageInputView.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(35)
        }

        messageTextField.snp.makeConstraints { make in
            make.left.equalTo(messageInputView).inset(8)
            make.centerY.equalTo(messageInputView)
            make.right.equalTo(sendButton.snp.left).offset(-8)
        }

        sendButton.snp.makeConstraints { make in
            make.right.equalTo(messageInputView).inset(8)
            make.centerY.equalTo(messageInputView)
            make.width.equalTo(35)
        }
    }

    private func setupLayout() {
        let additionalSpacing: CGFloat = 5
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(messageInputView.snp.top).offset(-additionalSpacing)
        }
        
        view.layoutIfNeeded()
    }


    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
        let message = messages[indexPath.item]

        if let user = self.user {
            cell.configure(with: user, message: message)
        }

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 50)
    }

   

    // MARK: - Message Sending

    @objc private func sendMessage() {
        guard let text = messageTextField.text, !text.isEmpty else {
            print("Message text is empty")
            return
        }

        guard let senderId = user?.id, let receiverId = receiverId else {
            print("Sender ID or Receiver ID is missing")
            return
        }
     
        APICaller.sendMessage(messageContent: text, receiverId: receiverId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.fetchMessages(for: receiverId)
                    self.messageTextField.text = ""
                    self.scrollToBottom()
                case .failure(let error):
                    self.showError(error)
                }
            }
        }

    }

    // MARK: - Error Handling
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
       guard let userInfo = notification.userInfo,
             let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
             let customKeyboardHeight: CGFloat = 310.0

       messageInputView.snp.updateConstraints { make in
           make.bottom.equalTo(view.safeAreaLayoutGuide).inset(customKeyboardHeight)
       }

       UIView.animate(withDuration: animationDuration) {
           self.view.layoutIfNeeded()
       }
   }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        messageInputView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
