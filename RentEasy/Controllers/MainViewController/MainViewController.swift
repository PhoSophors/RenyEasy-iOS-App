import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let createVC = PostViewController()
        let favoriteVC = FavoriteViewController()
        let profileVC = ProfileViewController()
        
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysTemplate)
        )
        homeVC.tabBarItem.tag = 0
        
        searchVC.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")?.withRenderingMode(.alwaysTemplate)
        )
        searchVC.tabBarItem.tag = 1
        
        createVC.tabBarItem = UITabBarItem(
            title: "Create",
            image: UIImage(systemName: "plus.circle")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        )
        createVC.tabBarItem.tag = 2
        
        favoriteVC.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        )
        favoriteVC.tabBarItem.tag = 3
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
        )
        profileVC.tabBarItem.tag = 4
        
        self.viewControllers = [homeVC, searchVC, createVC, favoriteVC, profileVC]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ProfileViewController {
            let newVC = ProfileViewController()
            newVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(newVC, animated: true)
            return false
        }
        return true
    }
}
