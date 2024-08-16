import UIKit
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let heroCollectionView = HeroCollectionView()
    private let categoryCollectionViewCell = HomeCategoryCollectionViewCell()
    private let allRentCollectionViewCell = AllRentCollectionViewCell()
    private var vilaCollectionView: UICollectionView!
    private var allRentCollectionView: UICollectionView!
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var vilaPosts: [AllPostsResponse.PostData.Post] = []
    private var allPosts: [AllPostsResponse.PostData.Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupHeroCollectionView()
        setupCategoryCollectionView()
        vilaLabelView()
        setupVilaCollectionView()
        allRentLabelView()
        setupAllRentCollectionView()
        
        fetchPosts()

        let settingsImage = UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        self.navigationItem.rightBarButtonItem = settingsButton

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .black
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }

    private func setupHeroCollectionView() {
        contentView.addSubview(heroCollectionView)
        heroCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    private func setupCategoryCollectionView() {
        contentView.addSubview(categoryCollectionViewCell)
        categoryCollectionViewCell.snp.makeConstraints { make in
            make.top.equalTo(heroCollectionView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
    }

    private func vilaLabelView() -> UIStackView {
        let label = UILabel()
        label.text = "Vila"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        
        let seeMoreLabel = UILabel()
        seeMoreLabel.text = "See more"
        seeMoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        seeMoreLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [label, seeMoreLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionViewCell.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(30)
        }
        
        return stackView
    }

    private func setupVilaCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.6, height: 270) // Adjust width to 60% of screen width
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        vilaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vilaCollectionView.delegate = self
        vilaCollectionView.dataSource = self
        vilaCollectionView.backgroundColor = .white
        vilaCollectionView.showsHorizontalScrollIndicator = false
        vilaCollectionView.register(VilaCollectionViewCell.self, forCellWithReuseIdentifier: VilaCollectionViewCell.identifier)

        contentView.addSubview(vilaCollectionView)
        let labelView = vilaLabelView()

        vilaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(270)
        }
    }

    private func allRentLabelView() -> UIStackView {
        let label = UILabel()
        label.text = "All"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        
        let seeMoreLabel = UILabel()
        seeMoreLabel.text = "See more"
        seeMoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        seeMoreLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [label, seeMoreLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(vilaCollectionView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(30)
        }
        
        return stackView
    }
    
    private func setupAllRentCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.5, height: 250) // Adjust width to 60% of screen width
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

        // Initialize collection view with the layout
        allRentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        allRentCollectionView.delegate = self
        allRentCollectionView.dataSource = self
        allRentCollectionView.backgroundColor = .white
        allRentCollectionView.showsVerticalScrollIndicator = false
        allRentCollectionView.register(AllRentCollectionViewCell.self, forCellWithReuseIdentifier: AllRentCollectionViewCell.identifier)

        // Add collection view to the view hierarchy
        contentView.addSubview(allRentCollectionView)
        let labelView = allRentLabelView()

        // Apply constraints using SnapKit
        allRentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.height.equalTo(250)
        }
    }


    
    private func fetchPosts() {
        APICaller.fetchAllPostByProperty(propertytype: "villa") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostByProperty):
                    self?.vilaPosts = allPostByProperty.data.posts
                    self?.vilaCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch vila posts: \(error)")
                }
            }
        }
        
        // Fetch all posts
        APICaller.fetchAllPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostsResponse):
                    self?.allPosts = allPostsResponse.data.posts
                    self?.allRentCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to fetch all posts: \(error)")
                }
            }
        }
    }

    // MARK: - UICollectionViewDataSource for Vila
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vilaCollectionView {
            return vilaPosts.count
        } else {
            return allPosts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == vilaCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VilaCollectionViewCell.identifier, for: indexPath) as? VilaCollectionViewCell else {
                return UICollectionViewCell()
            }

            let post = vilaPosts[indexPath.item]
            let imageUrl = post.images.first

            cell.configure(with: imageUrl, title: post.title, location: post.location, property: post.propertyType, price: post.price)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRentCollectionViewCell.identifier, for: indexPath) as? AllRentCollectionViewCell else {
                return UICollectionViewCell()
            }

            let post = allPosts[indexPath.item]
            let imageUrl = post.images.first

            cell.configure(with: imageUrl, title: post.title, location: post.location, property: post.propertyType, price: post.price)

            return cell
        }
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = allPosts[indexPath.item] // Adjust based on the selected collection view
        // Handle item selection, e.g., navigate to a detail view
    }
    
    @objc private func settingsButtonTapped() {
        // Handle settings button tap
    }
}
