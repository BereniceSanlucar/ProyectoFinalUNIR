//
//  UserProfileHeaderView.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 13/12/20.
//

import UIKit
import Firebase

class UserProfileHeaderView: UICollectionReusableView {
    // MARK: Properties
    var user: User? {
        didSet {
            //setProfileImage()
            profileImageView.image = UIImage(named: "fakeUser")
            usernameLabel.text = "Alejandro" //user?.username
        }
    }
    
    // MARK: UI elements
    private let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.borderWidth = 3.0
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemIndigo.cgColor
        imageView.layer.cornerRadius = 80/2
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var gridButton: UIButton = {
        return createButton(with: "square.grid.3x3.fill", selector: #selector(handleGridButton), tintColor: UIColor.systemIndigo)
    }()
    
    private lazy var listButton: UIButton = {
        return createButton(with: "list.star", selector: #selector(handleListButton))
    }()
    
    private lazy var bookmarkButton: UIButton = {
        return createButton(with: "bookmark", selector: #selector(handleBookmarkButton))
    }()
    
    private lazy var postsLabel: UILabel = {
        return createLabel(with: "11\nposts")
    }()
    
    private lazy var followersLabel: UILabel = {
        return createLabel(with: "0\nfollowers")
    }()
    
    private lazy var followingLabel: UILabel = {
        return createLabel(with: "0\nfollowing")
    }()
    
    private let editProfileButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = UIColor.systemIndigo
        button.setTitle("Edit Profile", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBackground, for: UIControl.State.normal)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        return button
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private methods
private extension UserProfileHeaderView {
    func configureAutoLayout() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, paddingTop: 12.0, paddingLeft: 12.0, paddingRight: 0, paddingBottom: 0, height: 80.0, width: 80.0, centerX: nil, centerY: nil)
        
        let bottomToolbar: UIStackView = setupBottomToolbar(withSubviews: [gridButton, listButton, bookmarkButton])
        addSubview(bottomToolbar)
        bottomToolbar.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, height: 50.0, width: 0, centerX: nil, centerY: nil)
        
        let topDividerView: UIView = UIView()
        topDividerView.backgroundColor = UIColor.systemIndigo
        addSubview(topDividerView)
        topDividerView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomToolbar.topAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, height: 0.5, width: 0, centerX: nil, centerY: nil)
        
        let bottomDividerView: UIView = UIView()
        bottomDividerView.backgroundColor = UIColor.systemIndigo
        addSubview(bottomDividerView)
        bottomDividerView.anchor(top: bottomToolbar.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, height: 0.5, width: 0, centerX: nil, centerY: nil)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, leading: nil, trailing: nil, bottom: bottomToolbar.bottomAnchor, paddingTop: 20.0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, height: 0, width: 0, centerX: profileImageView.centerXAnchor, centerY: nil)
        
        let userStatsView: UIStackView = setupUserStatsView(withSubviews: [postsLabel, followersLabel, followingLabel])
        addSubview(userStatsView)
        userStatsView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, paddingTop: 12.0, paddingLeft: 12.0, paddingRight: -12.0, paddingBottom: 0, height: 50.0, width: 0, centerX: nil, centerY: nil)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: userStatsView.bottomAnchor, leading: userStatsView.leadingAnchor, trailing: userStatsView.trailingAnchor, bottom: nil, paddingTop: 8.0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, height: 0, width: 0, centerX: nil, centerY: nil)
    }
    
    func setProfileImage() {
        guard let user: User = user, let imageURL: URL = URL(string: user.profileImageURL) else { return }
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let data: Data = data {
                DispatchQueue.main.async { [weak self] in
                    guard let self: UserProfileHeaderView = self else { return }
                    self.profileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    func setupUserStatsView(withSubviews: [UIView]) -> UIStackView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: withSubviews)
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.leading
        return stackView
    }
    
    func setupBottomToolbar(withSubviews: [UIView]) -> UIStackView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: withSubviews)
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 10.0
        return stackView
    }
    
    func createButton(with imageName: String, selector: Selector, tintColor: UIColor = UIColor.systemGray) -> UIButton {
        let button: UIButton = UIButton()
        let imageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        let buttonImage: UIImage? = UIImage(systemName: imageName, withConfiguration: imageConfiguration)
        button.setImage(buttonImage, for: UIControl.State.normal)
        button.tintColor = tintColor
        button.addTarget(self, action: selector, for: UIControl.Event.touchUpInside)
        return button
    }
    
    func createLabel(with text: String) -> UILabel {
        let label: UILabel = UILabel()
        label.attributedText = getAttributedText(from: text)
        label.numberOfLines = Int.zero
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func getAttributedText(from text: String) -> NSAttributedString? {
        let dividedText: [Substring] = splitText(text)
        guard let first: Substring = dividedText.first, let last: Substring = dividedText.last else { return nil }
        let attributedText = NSMutableAttributedString(string: String("\(first)\n"), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.0)])
        attributedText.append(NSAttributedString(string: String(last), attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.0)]))
        return attributedText
    }
    
    func splitText(_ text: String) -> [Substring] {
        return text.split(separator: "\n")
    }
    
    // MARK: Selector methods
    @objc func handleGridButton() {
        let gridImageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        let gridImage: UIImage? = UIImage(systemName: "square.grid.3x3.fill", withConfiguration: gridImageConfiguration)
        gridButton.setImage(gridImage, for: UIControl.State.normal)
        gridButton.tintColor = UIColor.systemIndigo
        
        listButton.tintColor = UIColor.systemGray
        
        let bookmarkImageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        let bookmarkImage: UIImage? = UIImage(systemName: "bookmark", withConfiguration: bookmarkImageConfiguration)
        bookmarkButton.setImage(bookmarkImage, for: UIControl.State.normal)
        bookmarkButton.tintColor = UIColor.systemGray
    }
    
    @objc func handleListButton() {
        listButton.tintColor = UIColor.systemIndigo
        
        let gridImageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        let gridImage: UIImage? = UIImage(systemName: "square.grid.3x3", withConfiguration: gridImageConfiguration)
        gridButton.setImage(gridImage, for: UIControl.State.normal)
        gridButton.tintColor = UIColor.systemGray
        
        let bookmarkImageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        let bookmarkImage: UIImage? = UIImage(systemName: "bookmark", withConfiguration: bookmarkImageConfiguration)
        bookmarkButton.setImage(bookmarkImage, for: UIControl.State.normal)
        bookmarkButton.tintColor = UIColor.systemGray
    }
    
    @objc func handleBookmarkButton() {
        let bookmarkImageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        let bookmarkImage: UIImage? = UIImage(systemName: "bookmark.fill", withConfiguration: bookmarkImageConfiguration)
        bookmarkButton.setImage(bookmarkImage, for: UIControl.State.normal)
        bookmarkButton.tintColor = UIColor.systemIndigo
        
        listButton.tintColor = UIColor.systemGray
        
        let gridImageConfiguration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        let gridImage: UIImage? = UIImage(systemName: "square.grid.3x3", withConfiguration: gridImageConfiguration)
        gridButton.setImage(gridImage, for: UIControl.State.normal)
        gridButton.tintColor = UIColor.systemGray
    }
}
