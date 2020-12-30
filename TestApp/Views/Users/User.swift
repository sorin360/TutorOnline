//
//  User.swift
//  TestApp
//
//  Created by Lica Sorin on 30/12/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import Foundation

struct User {

    static var name = "name"
    static var email = "email"
    
    var id: String
    var name: String?
    var email: String

    init(dictionary: [String: Any], id: String) {
        self.id = id
        self.name = dictionary[User.name] as? String
        self.email = dictionary[User.email] as? String ?? ""
    }
    
}
