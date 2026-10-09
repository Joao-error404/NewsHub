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
        let favoritesViewController = FavoritesViewController()
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let discoveryNavigationController = UINavigationController(rootViewController: discoveryViewController)
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
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
        
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        viewControllers = [
            homeNavigationController,
            discoveryNavigationController,
            favoritesNavigationController
        ]
        
        selectedIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
