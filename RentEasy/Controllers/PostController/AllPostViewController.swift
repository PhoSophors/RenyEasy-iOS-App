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
    
    private let noPostsLabel: UIView = {
        let container = UIView()
        
        // Icon
        let iconImageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = ColorManagerUtilize.shared.forestGreen
        container.addSubview(iconImageView)
        
        // Text
        let textLabel = UILabel()
        textLabel.text = "No post found."
        textLabel.textAlignment = .center
        textLabel.textColor = .gray
        textLabel.font = .systemFont(ofSize: 16, weight: .medium)
        container.addSubview(textLabel)
        
        // Add constraints
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top)
            make.centerX.equalTo(container.snp.centerX)
            make.width.height.equalTo(100)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.centerX.equalTo(container.snp.centerX)
            make.bottom.equalTo(container.snp.bottom)
        }
        
        container.isHidden = true
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = propertyType?.capitalized ?? "All Posts"
        view.backgroundColor = .white
        
        setupNoPostsLabel()
        setupCollectionView()
        setupViewModelBindings()
        showLoadingOverlay()
        viewModel.fetchPosts(by: propertyType)
    }
    
    private func setupNoPostsLabel() {
        view.addSubview(noPostsLabel)
        noPostsLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
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
            self?.hideLoadingOverlay()
            self?.updateUI()
        }
        
        viewModel.onError = { [weak self] error in
            self?.hideLoadingOverlay()
            print("Failed to fetch posts: \(error)")
            
            // Update the UI to show noPostsLabel and hide collectionView
            self?.noPostsLabel.isHidden = false
            self?.collectionView.isHidden = true
        }
    }

    
    private func updateUI() {
        if viewModel.allPosts.isEmpty {
            noPostsLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            noPostsLabel.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    private func showLoadingOverlay() {
        LoadingOverlay.shared.show(over: self.view)
    }
    
    private func hideLoadingOverlay() {
        LoadingOverlay.shared.hide()
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
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = viewModel.allPosts[indexPath.item]
        
        let detailViewController = PostDetailViewController()
        detailViewController.configure(with: selectedPost)

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
