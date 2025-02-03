//
//  CustomTabBarController.swift
//  CustomTabBar
//
//  Created by Keihan Kamangar on 2021-06-07.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        delegate = self

        // swiftlint:disable:next force_cast
        let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
        
        // swiftlint:disable:next force_cast
        let settingsNav = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
        
        // swiftlint:disable:next force_cast
        let newPostVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! UINavigationController
        
        
        homeNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        settingsNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "settings"), selectedImage: UIImage(named: "settingsSelected"))
        newPostVC.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        
        let viewControllers = [homeNav, newPostVC, settingsNav]
        self.setViewControllers(viewControllers, animated: false)
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.routeToCreateNewAd()
        }
    }
    
    func routeToCreateNewAd() {
        ((viewControllers?.first as? UINavigationController)?.viewControllers.first as? CalendarViewController)?.showAddEvent()
    }
}

// MARK: - UITabBarController Delegate
extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }

        if selectedIndex == 1 {
            return false
        }
        
        return true
    }
}
