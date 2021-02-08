//
//  MainTabBarViewController.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 13/12/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension MainTabBarController {
    func createViewControllers() {
        let userProfileViewController = UserProfileViewController()
        
        let navigationViewController = UINavigationController()
    }
}
