//
//  SignUpViewController.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 12/12/20.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    // MARK: UI elements
    private let plusPhotoButton: UIButton = {
        let button: UIButton = UIButton()
        let imageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.small)
        let buttonImage: UIImage? = UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: imageConfiguration)
        button.setBackgroundImage(buttonImage, for: UIControl.State.normal)
        button.tintColor = UIColor.systemIndigo
        button.addTarget(self, action: #selector(handlePlusPhoto), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
        button.setTitle("Sign Up", for: UIControl.State.normal)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(handleSignUp), for: UIControl.Event.touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var emailTextField: UITextField = {
        createTextField(withTile: "Email", isSecureTextEntry: false)
    }()
    
    private lazy var usernameTextField: UITextField = {
        createTextField(withTile: "Username", isSecureTextEntry: false)
    }()
    
    private lazy var passwordTextField: UITextField = {
        createTextField(withTile: "Password", isSecureTextEntry: true)
    }()

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureAutoLayout()
    }
}

// MARK: Private methods
private extension SignUpViewController {
    func createTextField(withTile: String, isSecureTextEntry: Bool) -> UITextField {
        let textField: UITextField = UITextField()
        textField.placeholder = withTile
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.isSecureTextEntry = isSecureTextEntry
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: UIControl.Event.editingChanged)
        return textField
    }
    
    func createVerticalContainer(withSubviews: [UIView]) -> UIStackView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: withSubviews)
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 10.0
        return stackView
    }
    
    func configureAutoLayout() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, leading: nil, trailing: nil, bottom: nil, paddingTop: 40.0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, height: 140.0, width: 140.0, centerX: view.centerXAnchor, centerY: nil)
        
        let stackView: UIStackView = createVerticalContainer(withSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, paddingTop: 20.0, paddingLeft: 40.0, paddingRight: -40.0, paddingBottom: 0, height: 200.0, width: 0, centerX: nil, centerY: nil)
    }
    
    func isEmailValid() -> Bool {
        guard let email: String = emailTextField.text, !email.isEmpty else { return false }
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate: NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isUsernameValid() -> Bool {
        guard let username: String = usernameTextField.text, !username.isEmpty else { return false }
        let usernameRegex: String = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,12}$"
        let usernamePredicate: NSPredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
    
    func isPasswordValid() -> Bool {
        guard let password: String = passwordTextField.text, !password.isEmpty else { return false }
        let passwordRegex: String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{8}$"
        let passwordPredicate: NSPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func createAlert(withTitle title: String, message: String, buttonTitle: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveUserData(with result: AuthDataResult, userValues: [String: String]) {
        let values: [AnyHashable: Any] = [result.user.uid: userValues]
        Database.database().reference().child("users").updateChildValues(values) { [weak self] (error, reference) in
            guard let self: SignUpViewController = self else { return }
            if let _: Error = error {
                self.createAlert(withTitle: "Registration Error", message: "Failed to save user information", buttonTitle: "OK")
            } else {
                self.createAlert(withTitle: "Registration Success", message: "Successfully created user", buttonTitle: "OK")
            }
        }
    }
    
    func storageUserInformation(with result: AuthDataResult, username: String) {
        if let profileImage: UIImage = plusPhotoButton.image(for: UIControl.State.normal),
           let uploadData: Data = profileImage.jpegData(compressionQuality: 0.3) {
            let fileName = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(fileName).putData(uploadData, metadata: nil) { [weak self] (medata, error) in
                guard let self: SignUpViewController = self else { return }
                if let metadata: StorageMetadata = medata,
                   let profileImageURL = metadata.path {
                    let userValues: [String: String] = ["username": username, "profileImageURL": profileImageURL]
                    self.saveUserData(with: result, userValues: userValues)
                } else {
                    self.createAlert(withTitle: "Registration Error", message: "Failed to upload profile image", buttonTitle: "OK")
                }
            }
        } else {
            let userValues: [String: String] = ["username": username]
            saveUserData(with: result, userValues: userValues)
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.systemBackground
    }
    
    // MARK: Selector methods
    @objc func handleSignUp() {
        guard let email: String = emailTextField.text, !email.isEmpty,
              let username: String = usernameTextField.text, !username.isEmpty,
              let password: String = passwordTextField.text, !password.isEmpty else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self: SignUpViewController = self else { return }
            if let result: AuthDataResult = result {
                self.storageUserInformation(with: result, username: username)
            } else {
                self.createAlert(withTitle: "Registration Error", message: "Failed to create user", buttonTitle: "OK")
            }
        }
    }
    
    @objc func handleTextInputChange() {
        guard isEmailValid(), isUsernameValid(), isPasswordValid() else {
            signUpButton.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.backgroundColor = UIColor.systemIndigo
        signUpButton.isEnabled = true
    }
    
    @objc func handlePlusPhoto() {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage, for: UIControl.State.normal)
        } else if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage, for: UIControl.State.normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.bounds.width/2
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.layer.borderWidth = 5.0
        plusPhotoButton.layer.borderColor = UIColor.systemIndigo.cgColor
        
        dismiss(animated: true, completion: nil)
    }
}
