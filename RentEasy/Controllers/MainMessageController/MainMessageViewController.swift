import UIKit
import SnapKit
import SDWebImage

class MainMessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var users: [UserInfo] = []
    
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
        self.title = "All Users' Messages"
        
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
                    self?.updateUI()
                    
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
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
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCollectionViewCell")
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
        let user = users[indexPath.item]
        cell.configure(with: user)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 70)
    }
    
    // MARK: - Error Handling

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
