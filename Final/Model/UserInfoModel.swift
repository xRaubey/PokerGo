//
//  UserInfoModel.swift
//  Final
//
//  Created by Yuqing Yang on 4/28/23.
//

import Foundation
import Firebase
import FirebaseStorage


class UserInfoModel: ObservableObject{
    @Published var userImage: UIImage? = nil
    @Published var userName: String? = nil
    
    @Published var userWins: Int = 0
    
    @Published var allUsers: [UserInfo]? = nil
    
    
    
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    
    func getUserImage(uid: String) {
        
        if(uid == ""){
            return
        }
        
        let path = storageRef.child("\(uid)/profile.jpg")
        
        path.getData(maxSize: 5*1024*1024){ data, error in
            if let error = error {
                print("Image error: ", error)
            } else{
                self.userImage = UIImage(data: data!)
            }
        }
    }
    
    
    func getUserName(uid: String) {
    
        if(uid == ""){
            return
        }
        
        let path = ref.child("user").child(uid).child("account/username")
              
        path.observe(.value) { snapshot in
            self.userName = snapshot.value as? String ?? "Unknow"
        }
//        path.getData(completion: { error, snapshot in
//            guard error == nil else{
//                return
//            }
//            self.userName = snapshot?.value as? String ?? "Unkown"
//
//        })
    }
    
    
    func getUserWins(uid: String) {
    
        if(uid == ""){
            return
        }
        
        let path = ref.child("user").child(uid).child("account/wins")
              
        path.observe(.value) { snapshot in
            self.userWins = snapshot.value as? Int ?? 0
        }

    }
    
    
    
    func getAllUsers() {
        let path = ref.child("user")
        path.observe(DataEventType.value) { snapshot in
            var l = [UserInfo]()
            let allChildren = snapshot.children.allObjects as? [DataSnapshot] ?? []
            for child in allChildren{
                
                guard let username = child.childSnapshot(forPath: "account/username").value as? String else{
                    return
                }
                
                if(child.childSnapshot(forPath: "account/status").exists()){
                    guard let status = child.childSnapshot(forPath: "account/status").value as? String else{
                        return
                    }
                    if(status == "online"){
                        l.append(UserInfo(id: child.key, username: username))
                    }
                    
                }
                
                
//                l.append(UserInfo(id: child.key, username: username))
            }
            self.allUsers = l
//            print("all user = \(self.allUsers)")
        }
    }
}
