import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController: UIViewController
        
        if AuthManager.isLoggedIn() {
            initialViewController = MainViewController()
        } else {
            initialViewController = LoginViewController()
        }
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        // Set custom back button image globally
        let backButtonImage = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate)
        let backButtonAppearance = UIBarButtonItem.appearance()
        backButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
        backButtonAppearance.tintColor = .black
        
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: nil, action: nil)
        navigationController.navigationBar.backIndicatorImage = backButton.image
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backButton.image
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        
        self.window = window
      
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
       return .portrait
   }
}
