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
        
//        tabBar.isTranslucent = false
      tabBar.tintColor = .white //
        delegate = self
        
        // Instantiate view controllers
      // swiftlint:disable:next force_cast
        let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
        
      // swiftlint:disable:next force_cast
        let settingsNav = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
        
      // swiftlint:disable:next force_cast
        let newPostVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! UINavigationController
        
        
        // Create TabBar items
        homeNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        
        settingsNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "settings"), selectedImage: UIImage(named: "settingsSelected"))
        
        newPostVC.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        
        
        // Assign viewControllers to tabBarController
        let viewControllers = [homeNav, newPostVC, settingsNav]
        self.setViewControllers(viewControllers, animated: false)
        
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.routeToCreateNewAd()
        }
    }
    
    func routeToCreateNewAd() {
      // swiftlint:disable:next force_cast
        let createAdNavController = self.storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! UINavigationController
        createAdNavController.modalPresentationCapturesStatusBarAppearance = true
        self.present(createAdNavController, animated: true, completion: nil)
    }
}

// MARK: - UITabBarController Delegate
extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // Your middle tab bar item index.
        // In my case it's 1.
        if selectedIndex == 1 {
            return false
        }
        
        return true
    }
}
//
//// MARK: - View Controllers
//class HomeViewController: UIViewController {
//    override func viewDidLoad() {
//        navigationItem.title = "Home"
//    }
//}
//
//class SettingsViewController: UIViewController {
//    override func viewDidLoad() {
//        navigationItem.title = "Settings"
//    }
//}
//
//class NewPostViewController: UIViewController {
//    override func viewDidLoad() {
//        navigationItem.title = "New Post"
//    }
//}
