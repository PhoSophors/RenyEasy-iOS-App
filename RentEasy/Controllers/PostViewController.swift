import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let postView = PostView()
    private var selectedImages: [UIImage] = []
    private let imageCollectionView: UICollectionView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        view.addSubview(postView)
        
        postView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postView.uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoTapped), for: .touchUpInside)
        postView.priceTypeSegmentedControl.addTarget(self, action: #selector(discountTypeChanged(_:)), for: .valueChanged)
        postView.locationTextField.addTarget(self, action: #selector(locationTextFieldTapped), for: .editingDidBegin)
        postView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        
        view.addSubview(imageCollectionView)
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(postView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
    }
    
    private func setupCollectionView() {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @objc private func uploadPhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func discountTypeChanged(_ sender: UISegmentedControl) {
        let selectedDiscountType = sender.selectedSegmentIndex == 0 ? "%" : "$"
        print("Selected Discount Type: \(selectedDiscountType)")
    }
    
    @objc private func locationTextFieldTapped() {
        print("Location Text Field Tapped")
    }
    
    @objc private func postButtonTapped() {
        print("Post Button Tapped")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didPickMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
            imageCollectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView(image: selectedImages[indexPath.item])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
