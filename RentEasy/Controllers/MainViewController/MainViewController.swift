import UIKit
import SnapKit

class MainViewController: UIViewController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTabBar()
    }

    private func setupTabBar() {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        tabBarController.tabBar.barTintColor = .red
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.layer.masksToBounds = true
        tabBarController.tabBar.layer.borderWidth = 1
        tabBarController.tabBar.layer.borderColor = UIColor.white.cgColor

        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        homeNavVC.setNavigationBarHidden(true, animated: false) // Hide navigation bar in this navigation controller
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.fill"))
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        searchNavVC.setNavigationBarHidden(true, animated: false) // Hide navigation bar in this navigation controller
        
        let postVC = PostViewController()
        postVC.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus.app"), selectedImage: UIImage(systemName: "plus.app.fill"))
        let postNavVC = UINavigationController(rootViewController: postVC)
        postNavVC.setNavigationBarHidden(true, animated: false) // Hide navigation bar in this navigation controller
        
        let favVC = FavoriteViewController()
        favVC.tabBarItem = UITabBarItem(title: "Likes", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        let favNavVC = UINavigationController(rootViewController: favVC)
        favNavVC.setNavigationBarHidden(true, animated: false) // Hide navigation bar in this navigation controller
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        profileNavVC.setNavigationBarHidden(true, animated: false) // Hide navigation bar in this navigation controller

        tabBarController.viewControllers = [homeNavVC, searchNavVC, postNavVC, favNavVC, profileNavVC]
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
        tabBarController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
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

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.title == "Likes" {
            let favVC = FavoriteViewController()
            favVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(favVC, animated: true)
            return false
        }
        
        if viewController.tabBarItem.title == "Profile" {
            let profileVC = ProfileViewController()
            profileVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(profileVC, animated: true)
            return false
        }
        
        return true
    }
}
