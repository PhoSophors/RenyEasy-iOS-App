import Foundation
import UIKit

class ErrorHandlingUtility {
    
    static func handle(error: NetworkError, in viewController: UIViewController) {
        let errorMessage: String
        switch error {
        case .urlError:
            errorMessage = "URL Error"
        case .canNotParseData:
            errorMessage = "Failed to parse data"
        case .serverError(let message):
            errorMessage = message
        case .invalidCredentials(let message):
            errorMessage = message
        case .unauthorized:
            errorMessage = "Unauthorized access. Please check your credentials and try again."
        case .forbidden:
            errorMessage = "Access forbidden. You don't have permission to access this resource."
        case .notFound:
            errorMessage = "Resource not found. Please check the URL or try again later."
        }
        showAlert(with: errorMessage, in: viewController) {
            LoadingOverlay.shared.hide()
        }
    }
    
    private static func showAlert(with message: String, in viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
