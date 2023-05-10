//
//  SceneDelegate.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 03.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if AuthManager.shared.isSignedIn {
            window.rootViewController = MainTabBarController()
        } else {
            let vc = SignInViewController()
            let navVC = UINavigationController(rootViewController: vc)
            window.rootViewController = navVC
        }
       
        window.makeKeyAndVisible()
        self.window = window
    }
}

