//
//  LoginModel.swift
//  Final
//
//  Created by Yuqing Yang on 4/17/23.
//

import Foundation
import Firebase
class LoginModel: ObservableObject{
    
    @Published var loginSession = false
    
    @Published var loginLoading = false
    
    var ref = Database.database().reference()
    var uid = Auth.auth().currentUser?.uid ?? "unknow_id"

    func logIn(uid: String){
//        print("login = \(uid)")
        let path = ref.child("user").child(uid).child("account").child("status")
        path.setValue("online")
        loginSession = true
    }
    
    func logOut(uid: String){
        let path = ref.child("user").child(uid).child("account").child("status")
        path.setValue("offline")
        loginSession = false
    }
    
    func getSession() -> Bool {
        return loginSession;
    }

}

