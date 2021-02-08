//
//  User.swift
//  InstantArt
//
//  Created by Berenice Mendoza Sanlúcar on 13/12/20.
//

import Foundation

struct User {
    let username: String
    let profileImageURL: String
    
    init(values: [String: Any]) {
        self.username = values["username"] as? String ?? ""
        self.profileImageURL = values["profileImageURL"] as? String ?? ""
    }
}
