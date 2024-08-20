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
    private var viewModel: PostViewModel!

    private var propertyType: String?

    init(propertyType: String?) {
        self.propertyType = propertyType
        super.init(nibName: nil, bundle: nil)
        self.viewModel = PostViewModel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = propertyType?.capitalized ?? "All Posts"
        view.backgroundColor = .white

        setupCollectionView()
        setupViewModelBindings()
        viewModel.fetchPosts(by: propertyType)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(AllRentCollectionViewCell.self, forCellWithReuseIdentifier: AllRentCollectionViewCell.identifier)

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupViewModelBindings() {
        viewModel.onPostsFetched = { [weak self] in
            self?.collectionView.reloadData()
        }

        viewModel.onError = { error in
            print("Failed to fetch posts: \(error)")
        }
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allPosts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRentCollectionViewCell.identifier, for: indexPath) as? AllRentCollectionViewCell else {
            return UICollectionViewCell()
        }

        let post = viewModel.allPosts[indexPath.item]
        let imageUrl = post.images.first

        cell.configure(with: imageUrl, title: post.title, location: post.location, property: post.propertyType, price: post.price)

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let totalPadding: CGFloat = padding * 3
        let availableWidth = collectionView.frame.width - totalPadding
        let widthPerItem = availableWidth / 2

        return CGSize(width: widthPerItem, height: widthPerItem + 50)
    }
}
