//
//  UserView.swift
//  TestApp
//
//  Created by Lica Sorin on 13/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

struct UserView: View {
    
    @State var presentLogin = false
    
    var body: some View {
        
        VStack {
            Button("Logout") {
                try! Auth.auth().signOut()
                self.presentLogin = true
            }
            Text("Hello, World!").sheet(isPresented: $presentLogin, onDismiss: {
                if Auth.auth().currentUser == nil {
                    self.presentLogin = true
                }
            }) {
                AuthView(presentLogin: self.$presentLogin)
            }.onAppear {
                if Auth.auth().currentUser == nil {
                    self.presentLogin = true
                }
                
            }
        }

    }
}
