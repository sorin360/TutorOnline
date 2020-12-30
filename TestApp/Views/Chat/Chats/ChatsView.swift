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
        
        Form {
            Text("fdf")
            ForEach(chats.chatsList, id: \.fromID) { chat in
                NavigationLink(destination: MessagesView(messages: Messages(userId: chat.fromID))) {
                    Text(chat.fromID)
                }
            }
        }.navigationBarTitle(Text("Chats"))
        
        
    }
}
