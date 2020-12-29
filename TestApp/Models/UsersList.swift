//
//  UsersList.swift
//  TestApp
//
//  Created by Lica Sorin on 13/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class UsersList: ObservableObject {

    @Published var users: [String] = []

    init() {

        Firestore
            .firestore()
            .collection("users")
            .addSnapshotListener { (querySnapshot, _) in
                self.users = querySnapshot?.documents.compactMap { $0.documentID } ?? []
        }
        //
        //        Database.database()
        //            .reference()
        //            .child("users")
        //            .observe(DataEventType.value) { (snapshot) in
        //                self.users = []
        //                (snapshot.value as? NSDictionary)?
        //                    .map { $1 as? NSDictionary }
        //                    .map { $0?["name"] as? String ?? ""}
        //                    .forEach { self.users += [$0] }
        //        }

    }
}

class PostsList: ObservableObject {

    @Published var posts: [Post] = []

    @Published var present = false

    init() {

        Firestore
            .firestore()
            .collection("posts")
            .addSnapshotListener { (querySnapshot, _) in
                self.posts = querySnapshot!.documents
                    .compactMap { (queryDocumentSnapshot) -> Post in
                        let post = Post(dictionary: queryDocumentSnapshot.data())
                        Storage.storage()
                            .reference(forURL: post.imageURL)
                            .getData(maxSize: 10 * 1024 * 1024) { (data, _) in
                            if let data = data {
                                post.image = UIImage(data: data)
                            }
                        }
                        return post
                }

        }

    }
}
