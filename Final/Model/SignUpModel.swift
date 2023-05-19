//
//  SignupModel.swift
//  Final
//
//  Created by Yuqing Yang on 4/18/23.
//

import Foundation
import Firebase

import Firebase
import FirebaseStorage


class SignUpModel: ObservableObject{
    
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    @Published var info = ""
    
    @Published var done: Bool = true
    
    func createUser(data: signupData) {
        
        
        objectWillChange.send()
        
        let d : [String: Any] = ["email": data.email, "username": data.username, "psw": data.psw, "status": "offline", "wins": 0]
        let i = data.image.jpegData(compressionQuality: 0.3)
        
        
        Auth.auth().createUser(withEmail: data.email, password: data.psw) { result, error in
            
            if let e = error{
                self.info = "\(e.localizedDescription.description)"
                self.done = true
            }
            else{
                if let uid = result?.user.uid {
                    self.ref.child("user").child(uid).child("account").setValue(d){
                        (error: Error?, ref:DatabaseReference) in
                        if let _ = error {
                            self.info = "Error while creating new account."
                            print("Error while creating new account.")
                            self.done = true
                        }
                        else{
                            let uimageRef = self.storageRef.child(uid).child("profile.jpg")
                            let metadata = StorageMetadata()
                            metadata.contentType = "image/jpeg"
                            
                            if let i = i{
                                uimageRef.putData(i, metadata: metadata){(metadata, error) in
                                    if let error = error{
                                        self.info = "Error while uploading file!"
                                        print("Error while uploading file",error)
                                        result?.user.delete{error in
                                            if let _ = error {
                                                self.done = true
                                                self.info = "Fail to delete the account!"
                                            }
                                            
                                        }
                                    }
                                    else{
                                        self.done = true
                                        self.info = "Done!"
                                    }
                                }
                            }
                        }
                        
                    }
                }
                else{
                    self.done = true
                    return
                }
                
            }
            
//            self.done = true
            
        }
        
        
    }
    
}
