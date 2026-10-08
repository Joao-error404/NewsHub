//
//  NavbarController.swift
//  NewsHub
//
//  Created by breno.farias on 08/10/26.
//

import UIKit

@MainActor
class NavbarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let homeViewController = HomeViewController()
        let discoveryViewController = DiscoveryViewController()
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let discoveryNavigationController = UINavigationController(rootViewController: discoveryViewController)
        
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Início",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        discoveryNavigationController.tabBarItem = UITabBarItem(
            title: "Explorar",
            image: UIImage(systemName: "safari"),
            selectedImage: UIImage(systemName: "safari.fill")
        )
        
        viewControllers = [
            homeNavigationController,
            discoveryNavigationController
        ]
        
        selectedIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
