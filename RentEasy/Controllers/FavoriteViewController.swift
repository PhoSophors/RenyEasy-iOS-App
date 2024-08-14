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
              let indexPath = collectionView?.indexPath(for: cell) else { return }
        
        let favorite = viewModel.favorites[indexPath.row]
        let favoriteId = favorite.id 
        
        viewModel.removeFavorite(favoriteId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print(message) // Log success message
                    // Remove the favorite from the view model and collection view
                    self?.viewModel.favorites.remove(at: indexPath.row)
                    self?.collectionView?.deleteItems(at: [indexPath])
                case .failure(let error):
                    print("Failed to remove favorite: \(error.localizedDescription)")
                }
            }
        }
    }
}
