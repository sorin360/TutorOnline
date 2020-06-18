//
//  HomeView.swift
//  TestApp
//
//  Created by Lica Sorin on 13/06/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import SwiftUI
import Firebase


struct HomeView: View {
    
    @ObservedObject var postsList = PostsList()
    
    var body: some View {
        VStack {
            Form {
                ForEach(postsList.posts, id: \.id) { post in
                    PostView(post: post)
                }
            }
            Button("Add Post") {
                self.postsList.present.toggle()
            }
        }.sheet(isPresented: $postsList.present) { NewPostView() }
    }
}

struct PostView: View {
    
    @ObservedObject var post: Post
    
    var body: some View {
        Section {
            Text(post.title ?? "")
            Text(post.description)
            post.image != nil ? Image(uiImage: post.image!).resizable().scaledToFit() : nil
        }
    }
}

struct NewPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showCamera = false
    
    @State var title = ""
    @State var description = ""
    @State var image: UIImage?
    @State var imageURL = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    image != nil ? Image(uiImage: image!).resizable().scaledToFit() : nil
                    NavigationLink(destination: UICustomImagePicker(isShown: $showCamera, sourceType: .photoLibrary){ self.image = $0 }
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                                   isActive: $showCamera, label: { Text("Upload image") })
                }
                Button("Add Post") {
                    let storageRef = Storage.storage().reference().child(UUID().uuidString + ".png")
                    storageRef.putData(self.image?.jpegData(compressionQuality: 0.1) ?? Data(), metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url?.absoluteString else {
                                print(error)
                                return
                            }
                            
                            Firestore.firestore()
                                .collection("posts")
                                .addDocument(data: ["id": UUID().uuidString,
                                                    "title":self.title,
                                                    "description":self.description,
                                                    "imageURL": downloadURL,
                                                    "user": Auth.auth().currentUser?.uid ?? ""])
                            
                        }
                        
                    }
                }
            }
        }
    }
}

class User: ObservableObject {
    
}

class Post: ObservableObject {
    var id: String
    var user: String
    var imageURL: String
    var title: String?
    var description: String
    @Published var image: UIImage?
    
    init(id: String, user: String, image: String, title: String?, description: String) {
        self.id = id
        self.user = user
        self.imageURL = image
        self.title = title
        self.description = description
    }
    
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as! String
        self.user = dictionary["user"] as! String
        self.imageURL = dictionary["imageURL"] as! String
        self.title = dictionary["title"] as? String
        self.description = dictionary["description"] as! String
    }
}

struct UICustomImagePicker: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    var sourceType: UIImagePickerController.SourceType
    
    var completionHandler: (_ image: UIImage) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, completionHandler: completionHandler)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UICustomImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<UICustomImagePicker>) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @Binding var isCoordinatorShown: Bool
        var completionHandler: (_ image: UIImage) -> Void
        
        init(isShown: Binding<Bool>, completionHandler: @escaping (_ image: UIImage) -> Void) {
            _isCoordinatorShown = isShown
            self.completionHandler = completionHandler
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //let imageData: Data = unwrapImage.jpegData(compressionQuality: 0.1)!
            completionHandler(unwrapImage)
            isCoordinatorShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isCoordinatorShown = false
        }
    }
    
}
