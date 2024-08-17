//
//  AllPostViewController.swift
//  RentEasy
//
//  Created by Apple on 17/8/24.
//

import UIKit
import SnapKit

class AllPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private var allPosts: [RentPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Post Page"
        view.backgroundColor = .white
        
        // Setup UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(AllPostCollectionViewCell.self, forCellWithReuseIdentifier: AllPostCollectionViewCell.identifier)

        view.addSubview(collectionView)
        
        // Layout the collectionView using SnapKit
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        fetchPosts()
    }

    private func fetchPosts() {
        // Fetch all posts
        APICaller.fetchAllPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostsResponse):
                    self?.allPosts = allPostsResponse.data.posts
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch all posts: \(error)")
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllPostCollectionViewCell.identifier, for: indexPath) as? AllPostCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let post = allPosts[indexPath.item]
        let imageUrl = post.images.first
        
        // Configure the cell with actual data
        cell.configure(with: imageUrl, title: post.title, location: post.location, property: post.propertyType, price: post.price)
        
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let totalPadding: CGFloat = padding * 3 // 2 spaces between items and 1 padding for each side of the collectionView
        let availableWidth = collectionView.frame.width - totalPadding
        let widthPerItem = availableWidth / 2

        return CGSize(width: widthPerItem, height: widthPerItem + 50)
    }
}
