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
            List(messages.messagesList
                    .sorted { $0.timeStamp > $1.timeStamp }
                 , id: \.id) { message in
                HStack {
                    message.local ? Spacer() : nil
                    Text(message.text)
                    !message.local ? Spacer() : nil
                }
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
