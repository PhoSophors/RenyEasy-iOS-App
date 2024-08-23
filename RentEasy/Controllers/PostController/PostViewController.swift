import UIKit
import PhotosUI

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoGalaryCollectionViewCellDelegate {

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

    // UICollectionViewDelegateFlowLayout method to define the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let maxHeight: CGFloat = 180 // Set your maximum height here

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
        
        let photoDetailVC = PhotoDetailPageViewController(images: selectedImages, initialIndex: tappedImageView.tag)
        photoDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }

    // MARK: - PhotoGalaryCollectionViewCellDelegate

    func didTapRemoveButton(cell: PhotoGalaryCollectionViewCell) {
        if let indexPath = postView.photoCollectionView.indexPath(for: cell) {
            selectedImages.remove(at: indexPath.item)
            postView.photoCollectionView.deleteItems(at: [indexPath])
        }
    }

    // Helper function to show alerts
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Limit Reached", message: message, preferredStyle: .alert)
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
            showAlert(message: "You can only add up to \(maxPhotos) photos.")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate (iOS 13)

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let maxPhotos = PhotoPrivacyManager.getPostPhotoLimit()
                
                if self.selectedImages.count < maxPhotos {
                    self.selectedImages.append(image)
                    self.postView.photoCollectionView.reloadData()
                } else {
                    self.showAlert(message: "You can only add up to \(maxPhotos) photos.")
                }
            }
        }
    }
}
