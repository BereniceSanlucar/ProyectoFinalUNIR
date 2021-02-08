//
//  LoginViewController.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 19/12/20.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: UI elements
    let signUpButton: UIButton = {
        let button: UIButton = UIButton()
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.0)])
        attributedText.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemIndigo, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.0)]))
        button.setAttributedTitle(attributedText, for: UIControl.State.normal)
        return button
    }()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        configureAutoLayout()
    }
}

// MARK: Private methods
extension LoginViewController {
    func configureAutoLayout() {
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -12, height: 50.0, width: 0, centerX: nil, centerY: nil)
    }
}
