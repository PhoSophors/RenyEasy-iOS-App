import UIKit

class KeyboardManager {
    private weak var view: UIView?
    private weak var collectionView: UICollectionView?
    private weak var inputView: UIView?
    
    private var bottomConstraint: NSLayoutConstraint?
    
    init(view: UIView, collectionView: UICollectionView, inputView: UIView) {
        self.view = view
        self.collectionView = collectionView
        self.inputView = inputView
    }
    
    func startObservingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func stopObservingKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let view = view,
              let inputView = inputView else { return }
        
        let keyboardHeight = keyboardFrame.height
        adjustInputViewForKeyboard(height: keyboardHeight)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        adjustInputViewForKeyboard(height: 0)
    }
    
    private func adjustInputViewForKeyboard(height: CGFloat) {
        guard let view = view,
              let inputView = inputView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = -height
            view.layoutIfNeeded()
        }
    }
    
    func setupConstraints() {
        guard let view = view, let inputView = inputView else { return }
        
        inputView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = inputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
        inputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 22).isActive = true
        inputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -22).isActive = true
        inputView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
