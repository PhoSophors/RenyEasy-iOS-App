import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white

        self.tabBar.backgroundColor = .white
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.tintColor = .black
        self.delegate = self
        
        // Add border to tab bar
        self.tabBar.layer.borderColor = UIColor.gray.cgColor
        self.tabBar.layer.borderWidth = 0.2
        self.tabBar.layer.masksToBounds = true
        
        setupViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        // Hide the navigation bar
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        // Ensure the navigation bar is visible when this view controller is not visible
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let createVC = PostViewController()
        let favoriteVC = FavoriteViewController()
        let profileVC = ProfileViewController()
        
        // Embed each view controller in a navigation controller
        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let createNav = UINavigationController(rootViewController: createVC)
        let favoriteNav = UINavigationController(rootViewController: favoriteVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        searchNav.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        createNav.tabBarItem = UITabBarItem(
            title: "Create",
            image: UIImage(systemName: "plus.circle")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        favoriteNav.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        self.viewControllers = [homeNav, searchNav, createNav, favoriteNav, profileNav]
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is ProfileViewController {
//            let newVC = ProfileViewController()
//            newVC.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(newVC, animated: true)
//            return false
//        }
//        return true
//    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navigationController = viewController as? UINavigationController,
           let profileVC = navigationController.viewControllers.first as? ProfileViewController {
            let newVC = ProfileViewController()
            newVC.hidesBottomBarWhenPushed = true
            
            // Push the newVC on the navigation stack of the selected tab
            if let selectedNavController = self.selectedViewController as? UINavigationController {
                selectedNavController.pushViewController(newVC, animated: true)
                return false
            }
        }
        return true
    }
}
