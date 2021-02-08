//
//  MainTabBarController.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 13/12/20.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _: FirebaseAuth.User = Auth.auth().currentUser else {
            DispatchQueue.main.async { [weak self] in
                guard let self: MainTabBarController = self else { return }
                self.present(LoginViewController(), animated: true, completion: nil)
            }
            return
        }
        setupUI()
        createViewControllers()
    }
}

// MARK: Private methods
private extension MainTabBarController {
    func createViewControllers() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let userProfileViewController = UserProfileViewController(collectionViewLayout: flowLayout)
        
        let navigationController = UINavigationController(rootViewController: userProfileViewController)
        navigationController.navigationBar.barTintColor = UIColor.systemIndigo
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        
        let userProfileImage: UIImage? = UIImage(systemName: "person")?.withTintColor(UIColor.systemBackground, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        navigationController.tabBarItem.image = userProfileImage
        
        let userProfileSelectedImage: UIImage? = UIImage(systemName: "person.fill")?.withTintColor(UIColor.systemBackground, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = userProfileSelectedImage
        
        viewControllers = [navigationController, UIViewController()]
    }
    
    func setupUI() {
        tabBar.barTintColor = UIColor.systemIndigo
    }
}
