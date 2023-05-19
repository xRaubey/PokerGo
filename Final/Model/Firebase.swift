//
//  Firebase.swift
//  Final
//
//  Created by Yuqing Yang on 4/18/23.
//

import Foundation
import Firebase
import MapKit

class Firebase: ObservableObject{
    
    @Published var ulocations = [Location]()
    
    @Published
    var count = 0
    
    var ref = Database.database().reference()
    
    
    func readCards(uid: String){
        
        objectWillChange.send()
        
        if(uid == "") {return }
        
//        let uid = Auth.auth().currentUser?.uid
        let child = ref.child("user").child(uid).child("annotations")
        
        
        child.observe(.value) { snapshot in
            var l = [Location]()
//            print(type(of: snapshot))
            
//            self.read = snapshot

//            self.count = Int(snapshot.childrenCount) as Int
//            print(self.count)
            

//            let allChildren = snapshot.children.allObjects as! [DataSnapshot]
//
//            print(allChildren[0].childSnapshot(forPath: "latitude").value)
            
            
//            let allChildren = snapshot.children.allObjects as? [DataSnapshot] ?? []
            
            let allChildren = snapshot.children.allObjects as? [DataSnapshot] ?? []

//
            for child in allChildren{
//                if let name = child.childSnapshot(forPath: "name").value as? String {
//                    print("aaa")
//                    print(name)
//                }

                guard let name = child.childSnapshot(forPath: "name").value as? String else{
                    return
                }

                guard let la = child.childSnapshot(forPath: "latitude").value as? Double else{
                    return
                }

                guard let lo = child.childSnapshot(forPath: "longtitude").value as? Double else{
                    return
                }

                l.append(Location(id: child.key, name: name, coordinate: CLLocationCoordinate2D(latitude: la, longitude: lo), type: "Random"))
            }

            self.ulocations = l
            
        }
//        print(self.ulocations)
    }
    
    
    func clearCard(uid: String) {
        objectWillChange.send()
        ref.child("user").child(uid).child("annotations").removeValue(){
            (error: Error?, ref:DatabaseReference) in
            if let _ = error {
                print("aa")
            }
            else{
                self.readCards(uid: uid)
            }
        }
//        readCards(uid: uid)
    }
    
    func addCard(uid: String, data: [String: Any]) {
        objectWillChange.send()
        
        ref.child("user").child(uid).child("annotations").childByAutoId().setValue(data){
            (error: Error?, ref:DatabaseReference) in
            if let _ = error {
                print("aa")
            }
            else{
                self.readCards(uid: uid)
            }
        }
//        readCards(uid: uid)
    }
    
    
    func addUserCard(uid: String, data: [String: Any]) {
        objectWillChange.send()
        
        ref.child("user").child(uid).child("cards").childByAutoId().setValue(data){
            (error: Error?, ref:DatabaseReference) in
            if let _ = error {
                print("aa")
            }
            else{
                self.readCards(uid: uid)
            }
        }
//        readCards(uid: uid)
    }
    
//    func updateCards(uid: String, data:  Location) {
//        
//        guard let key = ref.child("user").child(uid).child("annotations").childByAutoId().key else {return}
//        let d : [String : Any] = ["name":data.name, "latitude": data.coordinate.latitude as Double, "longtitude": data.coordinate.longitude as Double]
//        
//        let update = ["/user/\(uid)/annotations/\(key)": d]
//        
//        ref.updateChildValues(update)
//    }
    
//    func getCards() -> DataSnapshot {
//        return read!
//    }
    
    
}
