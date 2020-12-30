//
//  Chat.swift
//  TestApp
//
//  Created by Lica Sorin on 30/12/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import Foundation

struct Chat {

    var fromID: String

    init(fromID: String) {
        self.fromID = fromID
    }

    init(dictionary: [String: Any]) {
        self.fromID = dictionary["fromID"] as? String ?? ""
    }
}
