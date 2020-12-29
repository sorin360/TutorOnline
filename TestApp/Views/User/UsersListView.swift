//
//  UsersListView.swift
//  TestApp
//
//  Created by Lica Sorin on 13/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI

struct UsersListView: View {

    @ObservedObject var usersList = UsersList()

    var body: some View {
        NavigationView {
            List(usersList.users, id: \.self) { user in
                NavigationLink(destination: MessagesView(messages: Messages(userId: user))) {
                    Text(user)
                }

            }.navigationBarTitle(Text("Users"))
        }

    }
}
