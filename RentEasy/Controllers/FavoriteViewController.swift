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
        self.title = "Favorites"
        
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
        
        // Fetch favorites
        viewModel.fetchFavorites()
        viewModel.$favorites.sink { [weak self] _ in
            self?.collectionView?.reloadData()
            self?.refreshControl.endRefreshing()
        }.store(in: &cancellables)
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
        
        cell.heartIcon.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell selection
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
        let postId = favorite.post.id // Access the id from the favorite's post

        viewModel.removeFavorite(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }

                switch result {
                case .success(let message):
                    print("Success response: \(message)") // Log success message

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
}
