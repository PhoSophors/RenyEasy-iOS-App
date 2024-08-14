import UIKit
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let heroCollectionView = HeroCollectionView()
    private let categoryCollectionViewCell = HomeCategoryCollectionViewCell()
    private var vilaCollectionView: UICollectionView!
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupHeroCollectionView()
        setupCategoryCollectionView()
        vilaLabelView()
        setupVilaCollectionView()

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
        let labelView = vilaLabelView() // Get the stackView instance

        vilaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(16) // Use labelView instance here
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(270)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }



    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VilaCollectionViewCell.identifier, for: indexPath) as? VilaCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // Example data, replace with your data source
        let image = UIImage(named: "test1")
        let distance = "5 Km"
        let title = "Beautiful Villa"
        let address = "1234 Street Name, City"

        cell.configure(with: image, distance: distance, title: title, address: address)
        
        return cell
    }

    // MARK: - Actions

    @objc private func settingsButtonTapped() {
        // Navigate to settings
    }

    @objc private func chatButtonTapped() {
        // Navigate to chat
    }

    @objc private func profileButtonTapped() {
        // Navigate to user profile
    }

    @objc private func notificationButtonTapped() {
        // Navigate to notifications
    }
}
