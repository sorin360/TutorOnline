//
//  AuthView.swift
//  TestApp
//
//  Created by Lica Sorin on 13/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase

struct AuthView: View {

    @Binding var presentLogin: Bool

    @State private var option = 0

    var body: some View {
        Form {
            Section {
                Picker(selection: $option, label: EmptyView()) {
                    Text("Login").tag(0)
                    Text("Registration").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
            }
            option == 0 ? AnyView(LoginView(presentLogin: $presentLogin)) :  AnyView(RegistrationView())

        }
    }
}
struct LoginView: View {

    @Binding var presentLogin: Bool

    @State var name = ""
    @State var email = ""
    @State var password = ""

    var body: some View {
        Group {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Login") {
                Auth.auth().signIn(withEmail: self.email, password: self.password) { _, error in
                    guard error == nil else {
                        print("Create user error: \(error!)")
                        return
                    }
                    self.presentLogin = false
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
                    Firestore
                        .firestore()
                        .collection("users")
                        .document(authResult?.user.uid ?? "")
                        .setData(["name": self.name, "email": self.email, "password": self.password])

//                    let ref = Database.database().reference()
//                    ref.child("users")
//                        .child(authResult?.user.uid ?? "")
//                        .updateChildValues(["name":self.name, "email":self.email, "password":self.password]) { (error, databaseReference) in
//                        guard error == nil else {
//                            print("Add user in database error: \(error!)")
//                            return
//                        }
//                    }
                }

            }
        }
    }
}
