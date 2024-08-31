import UIKit
import SnapKit

class MessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var user: UserInfo?
    private var messages: [MessageModel] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Messages with \(user?.username ?? "Unknown")"
        view.backgroundColor = .white
        
        setupCollectionView()
        setupLayout()
        
        if let userId = user?.id {
            fetchMessages(for: userId)
        }
        
        // Fetch messages for the selected user
        fetchMessages(for: user?.id ?? "de")
    }
    
    private func fetchMessages(for userId: String) {
           APICaller.fetchAllMessages { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let response):
                       // Filter messages specifically for the selected user
                       self?.messages = response.data.messages.filter {
                           $0.senderId == userId || $0.receiverId == userId
                       }
                       // Reload your view here with new messages, if using a table or collection view
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
        }
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCollectionViewCell")
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
        let message = messages[indexPath.item]
        
        // Assuming `user` is the instance of UserInfo for the message's sender
        if let user = self.user {
            // Configure the cell with user and message data
            cell.configure(with: user, message: message)
        }
        
        return cell
    }


    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 50)
    }

    // MARK: - Error Handling

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
