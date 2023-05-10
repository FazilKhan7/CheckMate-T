//
//  MainTabBarController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 11.04.2023.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill"), selectedImage: nil)
    
        let messageVC = MessageViewController()
        messageVC.tabBarItem = UITabBarItem(title: "Message", image: UIImage(systemName: "message"), tag: 1)
        
        let statistics = StatisticsViewController()
        statistics.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.bar.fill"), tag: 2)
        
        let messageNC = UINavigationController(rootViewController: messageVC)
        let statisticsNC = UINavigationController(rootViewController: statistics)

        viewControllers = [homeVC, messageNC, statisticsNC]
        loadAllControllers()
    }
    
    func loadAllControllers() {
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let navVC = viewController as? UINavigationController {
                    let _ = navVC.viewControllers.first?.view
                }
            }
        }
    }
}
