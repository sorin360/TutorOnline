//
//  MessagesView.swift
//  TestApp
//
//  Created by Lica Sorin on 18/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

struct MessagesView: View {
    
    @ObservedObject var messages: Messages
    
    var body: some View {
        VStack {
            List(messages.messagesList, id: \.id) { message in
                Text(message.text)
            }
            HStack {
                TextField("Text", text: $messages.text)
                Button("Send") {
                    self.messages.send()
                }
            }
        }
        
    }
}

class Messages: ObservableObject {
    
    var userId: String
    
    @Published var text = ""
    
    @Published var messagesList: [Message] = []
    
    init(userId: String) {
        
        self.userId = userId
    }
    
    func send() {
        Firestore.firestore()
            .collection("chat")
            .document(userId)
            .collection("chats")
        .document(Auth.auth().currentUser?.uid ?? "nil")
        .collection("messages")
            .addDocument(data: ["text" : text, "timeStamp" : Date().timeIntervalSince1970])
    }
}

struct Message {
    
    var id = UUID()
    var text: String
    var timeStamp: String
    
    init(text: String, timeStamp: String) {
        self.text = text
        self.timeStamp = timeStamp
    }
    
    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as! String
        self.timeStamp = dictionary["timeStamp"] as! String
    }
}
