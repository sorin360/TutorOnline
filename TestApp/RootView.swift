//
//  ContentView.swift
//  TestApp
//
//  Created by Lica Sorin on 03/12/2019.
//  Copyright © 2019 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

struct RootView: View {
    
    @State var presentLogin = false
    
    @State var selectedTab: String = "Users"
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                UsersView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag("Users")
                ChatsView()
                    .tabItem {
                        Image(systemName: "message")
                        Text("Home")
                    }
                    .tag("Chats")
                ProfileView(presentLogin: $presentLogin)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Home")
                    }
                    .tag("Profile")
            }.onAppear {
                if Auth.auth().currentUser == nil {
                    self.presentLogin = true
                }
            }.sheet(isPresented: $presentLogin) {
                AuthView(presentLogin: self.$presentLogin)
            }
            .navigationBarTitle(selectedTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
