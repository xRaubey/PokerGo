//
//  CustomCardModel.swift
//  Final
//
//  Created by Yuqing Yang on 4/23/23.
//

import Foundation
import SwiftUI
import Firebase
import MapKit

struct cardContent {
    let suit: String
    let value: String
}


class CustomCardModel: ObservableObject{
    @Published var place: Bool = false
    
    var ref = Database.database().reference()
    
    @Published var delete: Bool = false
    @Published var cardContent: cardContent?

//    @Published var customCards: [Location] = []

    
    @Published var customCards: [Location] = [Location(id: "xx", name: "custom", coordinate: CLLocationCoordinate2D(latitude: 40.0, longitude: -30.0), type: "User")]
    

    
//    func addCard(data: Location){
//        self.customCards.append(data)
//    }
    
    func placeCard(data: [String: Any]) {
        objectWillChange.send()
        
        if(data["name"] as! String != ""){
            ref.child("global").childByAutoId().setValue(data){
                (error: Error?, ref:DatabaseReference) in
                if let _ = error {
                    print("aa")
                }
                else{
                    self.delete = true
                    self.readCards()
                }
            }
        }

    }
    
    func readCards(){
        
        objectWillChange.send()

        let child = ref.child("global")
        child.observe(.value) { snapshot in
            
            
            var l = [Location]()
            let allChildren = snapshot.children.allObjects as? [DataSnapshot] ?? []
            for child in allChildren{
                guard let name = child.childSnapshot(forPath: "name").value as? String else{
                    return
                }
                guard let la = child.childSnapshot(forPath: "latitude").value as? Double else{
                    return
                }

                guard let lo = child.childSnapshot(forPath: "longtitude").value as? Double else{
                    return
                }
                l.append(Location(id: child.key, name: name, coordinate: CLLocationCoordinate2D(latitude: la, longitude: lo), type: "User"))
            }

            self.customCards = l
            
        }
    }
    
}
