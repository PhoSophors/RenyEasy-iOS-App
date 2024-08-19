import UIKit

class SeeMoreOptionsUtilize {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showOptions(from button: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sharePost = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
            self?.shareOptionTapped()
        }
        sharePost.setValue(UIImage(systemName: "arrowshape.turn.up.right.fill"), forKey: "image")
        sharePost.setValue(UIColor.black, forKey: "titleTextColor")
        
        let editPost = UIAlertAction(title: "Edit post", style: .default) { [weak self] _ in
            self?.editOptionTapped()
        }
        editPost.setValue(UIImage(systemName: "pencil"), forKey: "image")
        editPost.setValue(UIColor.black, forKey: "titleTextColor")
        
        let deletePost = UIAlertAction(title: "Delete post", style: .destructive) { [weak self] _ in
            self?.deleteButtonTapped()
        }
        deletePost.setValue(UIImage(systemName: "trash.fill"), forKey: "image")
        deletePost.setValue(UIColor.systemRed, forKey: "titleTextColor")
        
        alertController.addAction(sharePost)
        alertController.addAction(editPost)
        alertController.addAction(deletePost)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func shareOptionTapped() {
        let sharePostViewController = SharePostViewController()
        sharePostViewController.modalPresentationStyle = .fullScreen
        self.viewController?.present(sharePostViewController, animated: true, completion: nil)
    }
    
    private func editOptionTapped() {
        let editPostViewController = EditPostViewController()
        let navigationController = UINavigationController(rootViewController: editPostViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    private func deleteButtonTapped() {
       print("Delete Button tapped..!")
    }
}
