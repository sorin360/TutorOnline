//
//  ContentView.swift
//  TestApp
//
//  Created by Lica Sorin on 03/12/2019.
//  Copyright © 2019 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
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
                RegisterView()
            }.onAppear {
                if Auth.auth().currentUser == nil {
                    self.presentLogin = true
                }
                
            }
        }
        
    }
}


struct RegisterView: View {
    
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
        ContentView()
    }
}
