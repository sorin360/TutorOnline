//
//  UsersListView.swift
//  TestApp
//
//  Created by Lica Sorin on 13/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI

struct UsersView: View {

    @ObservedObject var users = Users()

    var body: some View {
       
            Form {
                ForEach(users.users, id: \.id) { user in
                    NavigationLink(destination: MessagesView(messages: Messages(userId: user.id))) {
                        Text(user.name ?? user.email)
                    }
                }
            }.navigationBarTitle(Text("Users"))
        

    }
}
