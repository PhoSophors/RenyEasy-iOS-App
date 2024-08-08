import UIKit

class Helper: NSObject {

    private weak var viewController: UIViewController?

    // Initializer
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
        setupSwipeGesture()
    }

    // MARK: - Setup swipe gesture
    private func setupSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .right
        viewController?.view.addGestureRecognizer(swipeGesture)
    }

    @objc private func handleSwipe() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
