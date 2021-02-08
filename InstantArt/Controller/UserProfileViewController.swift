//
//  UserProfileViewController.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 13/12/20.
//

import UIKit
import Firebase

class UserProfileViewController: UICollectionViewController {
    // MARK: Private properties
    private var user: User?
    private let cellID = "cellID"
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.layer.cornerRadius = 8.0
        cell.backgroundColor = UIColor.systemGray
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as? UserProfileHeaderView else { return UICollectionReusableView()}
        header.user = user
        return header
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 8.0)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    }
}

// MARK: Private methods
private extension UserProfileViewController {
    func fetchUser() {
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { [weak self] (snapshot) in
            guard let self: UserProfileViewController = self, let values: [String: Any] = snapshot.value as? [String: Any] else { return }
            self.user = User(values: values)
        }) { [weak self] (error) in
            guard let self: UserProfileViewController = self else { return }
            self.createAlert(withTitle: "Fetching error", message: "Failed to fetch user", buttonTitle: "OK")
        }
    }
    
    func createAlert(withTitle title: String, message: String, buttonTitle: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setupUI() {
        navigationItem.title = "Alejandro"//user?.username
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBackground
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.register(UserProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    // MARK: Selector methods
    @objc func handleLogOut() {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let logOutAction: UIAlertAction = UIAlertAction(title: "Log Out", style: UIAlertAction.Style.default) { [weak self] (_) in
            guard let self: UserProfileViewController = self else { return }
            do {
                try Auth.auth().signOut()
            } catch {
                self.createAlert(withTitle: "Sign out error", message: "Failed to sign out", buttonTitle: "OK")
            }
        }
        actionSheet.addAction(logOutAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        if let popover: UIPopoverPresentationController = actionSheet.popoverPresentationController, let tabBarController: UITabBarController = tabBarController {
            popover.sourceView = tabBarController.tabBar
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
}
