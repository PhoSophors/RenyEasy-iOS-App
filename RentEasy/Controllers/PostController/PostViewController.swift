import UIKit
import PhotosUI

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoGalaryCollectionViewCellDelegate, PostViewDelegate {
    
    private let postView = PostView()
    private var selectedImages: [UIImage] = []

    override func loadView() {
        view = postView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Post"
        setupCollectionView()
        postView.addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        postView.delegate = self
    }

    private func setupCollectionView() {
        postView.photoCollectionView.delegate = self
        postView.photoCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        postView.photoCollectionView.collectionViewLayout = layout
        
        postView.photoCollectionView.register(PhotoGalaryCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoGalaryCell")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let _: CGFloat = 180

        let width = (collectionView.frame.width / 3) - (layout.minimumInteritemSpacing / 1)
        return CGSize(width: width, height: width)
    }

    @objc private func addPhotoTapped() {
        let maxPhotos = PhotoPrivacyManager.getPostPhotoLimit()

        guard selectedImages.count < maxPhotos else {
            showAlert(message: "You can only add up to \(maxPhotos) photos.")
            return
        }

        PhotoPrivacyManager.checkPhotoLibraryPermission { [weak self] granted in
            if granted {
                self?.presentImagePicker()
            } else {
                self?.showAccessAlert()
            }
        }
    }

    private func presentImagePicker() {
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = PhotoPrivacyManager.getPostPhotoLimit() - selectedImages.count
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    private func showAccessAlert() {
        PhotoPrivacyManager.showAccessAlert(from: self)
    }

    // MARK: - PostViewDelegate

    func didTapCreatePostButton() {
        // Retrieve and validate the input fields
        let title = postView.titleTextField.text ?? ""
        let bedroomCount = postView.bedroomTextField.text ?? ""
        let bathroomCount = postView.bathroomTextField.text ?? ""
        let price = postView.priceTextField.text ?? ""
        let propertyType = postView.propertyTypeTextField.text ?? ""
        let locationType = postView.locationTypeTextField.text ?? ""
        let description = postView.descriptionTextView.text ?? ""
        let contact = postView.contactTextField.text ?? ""

        // Ensure required fields are not empty
        guard !title.isEmpty, !bedroomCount.isEmpty, !bathroomCount.isEmpty, !price.isEmpty, !propertyType.isEmpty, !locationType.isEmpty,!description.isEmpty, !contact.isEmpty else {
            showAlert(message: "Please fill in all required fields.")
            return
        }
        
        // Convert text fields to appropriate data types
        guard let bedrooms = Int(bedroomCount), bedrooms > 0 else {
            showAlert(message: "Please enter a valid number for bedrooms.")
            return
        }
        
        guard let bathrooms = Int(bathroomCount), bathrooms > 0 else {
            showAlert(message: "Please enter a valid number for bathrooms.")
            return
        }
        
        guard let priceValue = Int(price), priceValue > 0 else {
            showAlert(message: "Please enter a valid price.")
            return
        }

        guard selectedImages.count > 0 else {
            showAlert(message: "Please select at least one image.")
            return
        }
        
        // Convert selected images to Data
        let imageDataArray = selectedImages.compactMap { image -> Data? in
            return image.jpegData(compressionQuality: 0.8)
        }
        
        // Prepare post data dictionary for the API call
        let postData: [String: Any] = [
            "title": title,
            "content": description,
            "contact": contact,
            "location": locationType,
            "price": priceValue,
            "bedrooms": bedrooms,
            "bathrooms": bathrooms,
            "propertytype": propertyType
        ]
        
        LoadingOverlay.shared.show(over: self.view)
        
        // Call the API to create the new post
        APICaller.createNewPostWithImages(postData: postData, images: imageDataArray) { result in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hide()
                switch result {
                case .success(let response):
                    // Handle success response
                    print("Post created successfully: \(response)")
                    
                    // Clear form fields
                    self.postView.titleTextField.text = ""
                    self.postView.bedroomTextField.text = ""
                    self.postView.bathroomTextField.text = ""
                    self.postView.priceTextField.text = ""
                    self.postView.propertyTypeTextField.text = ""
                    self.postView.locationTypeTextField.text = ""
                    self.postView.descriptionTextView.text = ""
                    self.postView.contactTextField.text = ""

                    // Navigate to HomeViewController
                    let homeViewController = HomeViewController()
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                case .failure(let error):
                    print("Failed to create post: \(error)")
                    self.showAlert(message: "Failed to create post. Please try again.")
                }
            }
        }
    }


    // MARK: - UICollectionView DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGalaryCell", for: indexPath) as! PhotoGalaryCollectionViewCell
        cell.delegate = self
        
        let image = selectedImages[indexPath.item]
        let isRemovable = selectedImages.count > 0
        
        cell.configure(with: image, isRemovable: isRemovable)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapped(_:)))
        cell.getImageView().tag = indexPath.item
        cell.getImageView().addGestureRecognizer(tapGestureRecognizer)
        cell.getImageView().isUserInteractionEnabled = true

        return cell
    }

    // MARK: - Photo Detail Handling
    @objc private func photoTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        // Check if the index is valid
        let tappedIndex = tappedImageView.tag
        guard tappedIndex >= 0 && tappedIndex < selectedImages.count else {
            print("Invalid index for tapped photo.")
            return
        }
        
        // Create and present the photo detail view controller
        let photoDetailVC = PhotoDetailPageViewController(images: selectedImages, initialIndex: tappedIndex)
        photoDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }

    // MARK: - PhotoGalaryCollectionViewCellDelegate
//
//    func didTapRemoveButton(cell: PhotoGalaryCollectionViewCell) {
//        if let indexPath = postView.photoCollectionView.indexPath(for: cell) {
//            selectedImages.remove(at: indexPath.item)
//            postView.photoCollectionView.deleteItems(at: [indexPath])
//        }
//    }

    func didTapRemoveButton(cell: PhotoGalaryCollectionViewCell) {
        guard let indexPath = postView.photoCollectionView.indexPath(for: cell) else {
            print("Failed to get indexPath for the cell.")
            return
        }
        
        // Ensure the indexPath.item is within the bounds of the array
        guard indexPath.item < selectedImages.count else {
            print("Index out of range. The item at \(indexPath.item) does not exist in the selectedImages array.")
            return
        }

        // Remove image from data source
        selectedImages.remove(at: indexPath.item)

        // Delete the item from the collection view
        postView.photoCollectionView.performBatchUpdates({
            postView.photoCollectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    // Helper function to show alerts
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - PHPickerViewControllerDelegate (iOS 14+)

@available(iOS 14, *)
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        let maxPhotos = PhotoPrivacyManager.getPostPhotoLimit()
        let remainingSpace = maxPhotos - selectedImages.count

        let limitedResults = results.prefix(remainingSpace)

        for result in limitedResults {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let self = self, let image = image as? UIImage, error == nil else {
                        return
                    }

                    DispatchQueue.main.async {
                        self.selectedImages.append(image)
                        self.postView.photoCollectionView.reloadData()
                    }
                }
            }
        }

        if results.count > remainingSpace {
            showAlert(message: "You can only select up to \(maxPhotos) photos.")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImages.append(pickedImage)
            postView.photoCollectionView.reloadData()
        }
    }
}
