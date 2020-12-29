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

    var body: some View {

        TabView {
            HomeView().tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            ChatsView().tabItem {
                Image(systemName: "message")
                Text("Home")
            }
            UsersListView().tabItem {
                Image(systemName: "person")
                Text("Home")
            }

        }.onAppear {
            if Auth.auth().currentUser == nil {
                self.presentLogin = true
            }

        }.sheet(isPresented: $presentLogin) {
            AuthView(presentLogin: self.$presentLogin)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
