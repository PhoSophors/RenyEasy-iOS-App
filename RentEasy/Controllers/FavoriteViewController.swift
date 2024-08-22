//
//  FavoriteViewController.swift
//  RentEasy
//
//  Created by Apple on 4/8/24.
//

import UIKit
import Combine

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView?
    private var viewModel = FavoriteViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 10, height: 120)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .clear
        collectionView?.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        
        // Set up the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        // Fetch top 20 favorites
        viewModel.fetchFavorites()
        viewModel.$favorites.sink { [weak self] favorites in
            self?.collectionView?.reloadData()
            self?.refreshControl.endRefreshing()
            
            if favorites.isEmpty {
                self?.displayNoFavoritesMessage()
            } else {
                self?.hideNoFavoritesMessage()
            }
        }.store(in: &cancellables)
        
        setupNavigationBar()
    }
    
    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        // Set up the left label
        let leftLabel = UILabel()
        leftLabel.text = "Favorites"
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
        let seeAllImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        let seeAllButton = UIButton(type: .custom)
        seeAllButton.setImage(seeAllImage, for: .normal)
        seeAllButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        seeAllButton.layer.cornerRadius = 20
        seeAllButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        seeAllButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        
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
        let messageBarButtonItem = UIBarButtonItem(customView: seeAllButton)
        let notificationBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        // Set the right bar button items
        self.navigationItem.rightBarButtonItems = [messageBarButtonItem, notificationBarButtonItem]
        
        // Customize navigation bar appearance
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc private func refreshData() {
        viewModel.fetchFavorites()
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let favorite = viewModel.favorites[indexPath.row]
        cell.configure(with: favorite)
        
        // Initialize SeeMoreOptionsUtilize with the current view controller
        cell.seeMoreOptionsUtilize = SeeMoreOptionsUtilize(viewController: self)
        
        cell.heartIcon.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        cell.moreIcon.addTarget(self, action: #selector(moreIconTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func moreIconTapped(_ sender: UIButton) {
        // Handle the "more" button tap in the FavoriteViewController
        // This method will be called when the "more" button is tapped
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = viewModel.favorites[indexPath.row].post
        let detailViewController = PostDetailViewController()
        detailViewController.configure(with: selectedPost)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @objc private func heartButtonTapped(_ sender: UIButton) {
        // Safely unwrap the indexPath
        guard let cell = sender.superview?.superview as? UICollectionViewCell,
              let indexPath = collectionView?.indexPath(for: cell) else {
            print("Error: Unable to determine indexPath for cell")
            return
        }
        
        // Ensure the index path is within bounds
        guard indexPath.row < viewModel.favorites.count else {
            print("Error: Index out of range. indexPath.row: \(indexPath.row), favorites count: \(viewModel.favorites.count)")
            return
        }
        
        let favorite = viewModel.favorites[indexPath.row]
        let postId = favorite.post.id
        
        viewModel.removeFavorite(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let message):
                    print("Success response: \(message)")
                    
                    // Update the data source before attempting to delete from collection view
                    if let indexToRemove = strongSelf.viewModel.favorites.firstIndex(where: { $0.post.id == postId }) {
                        strongSelf.viewModel.favorites.remove(at: indexToRemove)
                        
                        // Perform batch updates to ensure collection view synchronization
                        strongSelf.collectionView?.performBatchUpdates({
                            // Ensure the index path is still valid
                            if strongSelf.collectionView?.numberOfItems(inSection: indexPath.section) ?? 0 > indexPath.row {
                                strongSelf.collectionView?.deleteItems(at: [indexPath])
                            } else {
                                print("Error: Index path out of bounds for deletion.")
                            }
                        }, completion: { _ in
                            // Optionally handle completion
                        })
                    }
                    
                case .failure(let error):
                    print("Failed to remove favorite: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - No Favorites Message Handling
    private func displayNoFavoritesMessage() {
        let bookmarkImageView = UIImageView(image: UIImage(systemName: "bookmark.fill"))
        bookmarkImageView.tintColor = .gray
        bookmarkImageView.tag = 1002
        bookmarkImageView.tintColor = ColorManagerUtilize.shared.forestGreen
        bookmarkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
      
        let noFavoritesLabel = UILabel()
        noFavoritesLabel.text = "No favorites yet."
        noFavoritesLabel.textColor = .gray
        noFavoritesLabel.textAlignment = .center
        noFavoritesLabel.font = UIFont.systemFont(ofSize: 18)
        noFavoritesLabel.tag = 1003
        noFavoritesLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let stackView = UIStackView(arrangedSubviews: [bookmarkImageView, noFavoritesLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.tag = 1001
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }

    private func hideNoFavoritesMessage() {
        if let stackView = view.viewWithTag(1001) {
            stackView.removeFromSuperview()
        }
    }

    
    // MARK: - Action
    @objc private func seeAllButtonTapped() {
        let allPostViewController = AllPostViewController(propertyType: nil) // Fetches all posts
        navigationController?.pushViewController(allPostViewController, animated: true)
    }
    
    @objc private func notificationButtonTapped() {
        let notificationViewController = NotificationViewController()
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
}
