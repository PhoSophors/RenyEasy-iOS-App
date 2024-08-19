//
//  SceneDelegate.swift
//  RentEasy
//
//  Created by Apple on 3/8/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let initialViewController: UIViewController
        
        if AuthManager.isLoggedIn() {
            initialViewController = MainViewController()
        } else {
            initialViewController = LoginViewController()
        }
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }


}

