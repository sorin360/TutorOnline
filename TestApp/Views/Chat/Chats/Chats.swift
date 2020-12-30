//
//  Chats.swift
//  TestApp
//
//  Created by Lica Sorin on 30/12/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

class Chats: ObservableObject {

    @Published var chatsList: [Chat] = []

    init() {

        Firestore.firestore()
            .collection("chat")
            .document(Auth.auth().currentUser?.uid ?? "nil")
            .collection("chats")
            .addSnapshotListener { (querySnapshot, _) in
                self.chatsList = querySnapshot?
                    .documents
                    .compactMap {  Chat(fromID: $0.documentID) } ?? []
            }

    }
}
