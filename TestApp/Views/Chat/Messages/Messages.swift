//
//  Messages.swift
//  TestApp
//
//  Created by Lica Sorin on 30/12/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

class Messages: ObservableObject {
    
    var userId: String
    
    @Published var text = ""

    @Published var messagesList: [Message] = []

    init(userId: String) {
        
        self.userId = userId
        
        Firestore.firestore()
            .collection("chat")
            .document(userId)
            .collection("chats")
            .document(Auth.auth().currentUser?.uid ?? "nil")
            .collection("messages")
            .addSnapshotListener { (querySnapshot, _) in
                let newMessagesList = querySnapshot?
                    
                    .documents
                    .compactMap { Message(dictionary: $0.data(), local: true) }
                    .filter({ message in
                        !self.messagesList.contains(where: { $0.timeStamp == message.timeStamp} )
                    }) ?? []
                
                self.messagesList += newMessagesList
            }
        
        Firestore.firestore()
            .collection("chat")
            .document(Auth.auth().currentUser?.uid ?? "nil")
            .collection("chats")
            .document(userId)
            .collection("messages")
            .addSnapshotListener { (querySnapshot, _) in
                let newMessagesList = querySnapshot?
                    
                    .documents
                    .compactMap { Message(dictionary: $0.data(), local: false) }
                    .filter({ message in
                        !self.messagesList.contains(where: { $0.timeStamp == message.timeStamp} )
                    }) ?? []
                self.messagesList += newMessagesList
            }
    }
    
    func send() {
       
        Firestore.firestore()
            .collection("chat")
            .document(userId)
            .setData([:], merge: true)
        
        Firestore.firestore()
            .collection("chat")
            .document(userId)
            .collection("chats")
            .document(Auth.auth().currentUser?.uid ?? "nil")
            .setData([:], merge: true)
        
        Firestore.firestore()
            .collection("chat")
            .document(userId)
            .collection("chats")
            .document(Auth.auth().currentUser?.uid ?? "nil")
            .collection("messages")
            .addDocument(data: ["text": text, "timeStamp": Date().timeIntervalSince1970])
        
    }
}
