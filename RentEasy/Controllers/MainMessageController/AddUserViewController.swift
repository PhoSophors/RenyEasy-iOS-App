import UIKit
import SnapKit

protocol AddUserViewControllerDelegate: AnyObject {
    func didSelectUser(_ user: UserInfo)
}

class AddUserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    weak var delegate: AddUserViewControllerDelegate?

    private var users: [UserInfo] = []
    private var filteredUsers: [UserInfo] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchTextField = UITextField()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Add User for message"

        setupScrollView()
        setupSearchTextField()
        setupCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchTextField.delegate = self
        
        // Fetch initial data
        performSearch(query: "")
    }

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
        contentView.addSubview(searchTextField)
        
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Search users..."
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged) // Add target for search text change
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(contentView.snp.leading).inset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.height.equalTo(40)
        }
    }

    private func setupCollectionView() {
        // Initialize the collection view with a layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "UserCollectionViewCell")
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).inset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
            make.height.equalTo(500)
        }

        collectionView.backgroundColor = .red
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            print("Query is empty. No search performed.")
            self.users = []
            self.filteredUsers = []
            self.collectionView.reloadData()
            return
        }

        APICaller.searchPostsAndUsers(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Search successful: \(response)")
                    self.users = response.data.users
                    self.filteredUsers = self.users
                    self.collectionView.reloadData()
                    
                case .failure(let error):
                    print("Failed to search: \(error.localizedDescription)")
                    self.users = []
                    self.filteredUsers = []
                    self.collectionView.reloadData()
                }
            }
        }
    }

    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            // Handle empty or whitespace-only search text
            filteredUsers = []
            collectionView.reloadData()
            return
        }
        
        performSearch(query: searchText)
    }

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
