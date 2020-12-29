//
//  MessagesView.swift
//  TestApp
//
//  Created by Lica Sorin on 13/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

struct ChatsView: View {

    @ObservedObject var chats = Chats()

    var body: some View {
        NavigationView {
            Form {
                ForEach(chats.chatsList, id: \.fromID) { chat in
                    ChatView(chat: chat)
                }.navigationBarTitle(Text("Chats"))
            }
        }

    }
}

struct ChatView: View {

    @ObservedObject var chat: Chat

    var body: some View {

        Text(chat.fromID)

    }
}

class Chats: ObservableObject {

    @Published var chatsList: [Chat] = []

    init() {

//        Firestore.firestore()
//        .collection("chat")
//            .document(Auth.auth().currentUser?.uid ?? "nil")
//            .collection("chats")
//            .addSnapshotListener { (querySnapshot, _) in
//                
//                var chats = querySnapshot?.documents
//                    .filter {  }
//                    .compactMap { (queryDocumentSnapshot) -> Post in
//                        let post = Post(dictionary: queryDocumentSnapshot.data())
//                        Storage.storage()
//                            .reference(forURL: post.imageURL)
//                            .getData(maxSize: 10 * 1024 * 1024) { (data, error) in
//                            if let data = data {
//                                post.image = UIImage(data: data)
//                            }
//                        }
//                        return post
//                }
//        }
//        Database.database()
//            .reference()
//            .child("messages")
//            .child(Auth.auth().currentUser?.uid ?? "nil")
//            .child("received")
//            .observe(DataEventType.value) { (snapshot) in
//                self.chatsList = []
//                (snapshot.value as? NSDictionary)?
//                    .compactMap { $1 as? NSDictionary }
//                    .forEach {
//                        let chat = Chat(dictionary: $0)
//                        self.chatsList += [chat]
//                }
//        }

    }
}

//class Chats: ObservableObject {
//
//    @Published var chats: [Chat] = []
//
//    init() {
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
//
//    }
//}

class Chat: ObservableObject {

    var fromID: String

    init(fromID: String) {
        self.fromID = fromID
    }

    init(dictionary: NSDictionary) {
        self.fromID = dictionary["fromID"] as! String
    }
}
