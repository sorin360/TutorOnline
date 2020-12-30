//
//  Users.swift
//  TestApp
//
//  Created by Lica Sorin on 30/12/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

class Users: ObservableObject {

    @Published var users: [User] = []

    init() {

        Firestore
            .firestore()
            .collection("users")
            .addSnapshotListener { (querySnapshot, _) in
                self.users = querySnapshot?.documents
                    .compactMap {
                        User(dictionary: $0.data(),
                             id: $0.documentID)
                    } ?? []
        }


    }
}
