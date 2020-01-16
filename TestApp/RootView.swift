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
            UsersListView().tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
        }
    }
}

class UsersList: ObservableObject {
    
    @Published var users: [String] = []
    
    init() {
        let ref = Database.database().reference()
        
        ref.child("users").observe(DataEventType.value, with: { (snapshot) in
            self.users = []
            let values = snapshot.value as? NSDictionary
            values?.forEach({ (key, value) in
                let value = value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                self.users += [name]
            })
        })
    }
}
struct UsersListView: View {
    
    @ObservedObject var usersList = UsersList()
    
    var body: some View {
        NavigationView {
            List(usersList.users, id: \.self){ user in
                Text(user)
            }.navigationBarTitle(Text("Users"))
        }
        
    }
}

struct HomeView: View {
    
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
                AuthView()
            }.onAppear {
                if Auth.auth().currentUser == nil {
                    self.presentLogin = true
                }
                
            }
        }

    }
}




struct AuthView: View {
    @State private var option = 0
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $option, label: EmptyView()) {
                    Text("Login").tag(0)
                    Text("Registration").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
            }
            option == 0 ? AnyView(LoginView()) :  AnyView(RegistrationView())
            
        }
    }
}
struct LoginView: View {
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Login") {
                Auth.auth().signIn(withEmail: self.email, password: self.password) { authResult, error in
                    guard error == nil else {
                        print("Create user error: \(error!)")
                        return
                    }
                }
                
            }
        }
    }
}

struct RegistrationView: View {
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Register") {
                Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
                    guard error == nil else {
                        print("Create user error: \(error!)")
                        return
                    }
                    let ref = Database.database().reference()
                    ref.child("users").child(authResult?.user.uid ?? "").updateChildValues(["name":self.name, "email":self.email, "password":self.password], withCompletionBlock: { (error, databaseReference) in
                        guard error == nil else {
                            print("Add user in database error: \(error!)")
                            return
                        }
                    })
                }
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
