import UIKit
import SnapKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTabBar()
        setupNavigationBar()
    }

    private func setupTabBar() {
        // Create tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .red
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.layer.masksToBounds = true
        tabBarController.tabBar.layer.borderWidth = 1
        tabBarController.tabBar.layer.borderColor = UIColor.white.cgColor

        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.fill"))
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        
        let postVC = PostViewController()
        postVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus.app"), selectedImage: UIImage(systemName: "plus.app.fill"))
        let postNavVC = UINavigationController(rootViewController: postVC)
        
        let favVC = FavoriteViewController()
        favVC.tabBarItem = UITabBarItem(title: "Likes", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        let favNavVC = UINavigationController(rootViewController: favVC)

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        
        // Assign view controllers to the tab bar controller
        tabBarController.viewControllers = [homeNavVC, searchNavVC, postNavVC, favNavVC, profileNavVC]
        
        // Set tab bar controller as the child of MainViewController
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
        // Constraints for tabBarController's view using SnapKit
        tabBarController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        // Customize selected tab appearance
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white

            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.selected.iconColor = .black
            itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            itemAppearance.normal.iconColor = .gray
            itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance

            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
    }

    private func setupNavigationBar() {
        // Message button
        let messageButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.message.fill"), style: .plain, target: self, action: #selector(messageButtonTapped))
        messageButton.tintColor = .black
        
        // User button
        let userButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(userButtonTapped))
        userButton.tintColor = .black
        
        // Set left and right bar buttons
        navigationItem.leftBarButtonItem = userButton
        navigationItem.rightBarButtonItem = messageButton
    }
    @objc private func messageButtonTapped() {
        let messageVC = MainMessageViewController()
        
        // Set the modal presentation style
        messageVC.modalPresentationStyle = .pageSheet
        
        // Present the view controller
        present(messageVC, animated: true, completion: {
            print("Message button tapped")
        })
    }


    @objc private func userButtonTapped() {
        // Handle user button tap
        print("User button tapped")
    }
}
