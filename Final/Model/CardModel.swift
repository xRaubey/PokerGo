//
//  CardModel.swift
//  Final
//
//  Created by Yuqing Yang on 4/17/23.
//

import Foundation
import SwiftUI
import Firebase


class CardModel: ObservableObject{
    @Published var cards: [Card] = []
    var ref = Database.database().reference()
    
//    func addCard(card: Card){
//        objectWillChange.send()
//        cards.append(card)
//    }
    
    func addCard(data: [String: Any]) {
        objectWillChange.send()
        
//        let data = ["name":card.name]
        let uid = Auth.auth().currentUser?.uid as? String ?? ""
        ref.child("user").child(uid).child("cards").childByAutoId().setValue(data)
//        readCards(uid: uid)
    }
    
    
    func readCards(uid: String){
        
        objectWillChange.send()
        
        if(uid == "") {return }
//        let uid = Auth.auth().currentUser?.uid
        let child = ref.child("user").child(uid).child("cards")
        child.observe(.value) { snapshot in
            var l = [Card]()
            let allChildren = snapshot.children.allObjects as? [DataSnapshot] ?? []
            for child in allChildren{
                guard let name = child.childSnapshot(forPath: "name").value as? String else{
                    return
                }
                
                guard let value = child.childSnapshot(forPath: "value").value as? String else{
                    return
                }

                
                l.append(Card(id:child.key,name: name, value: value))
            }

            self.cards = l
            
        }
    }
    
    func removeCard(card: Card){
        objectWillChange.send()
        let uid = Auth.auth().currentUser?.uid as? String ?? ""
        ref.child("user").child(uid).child("cards").child(card.id).removeValue(){
            (error: Error?, ref:DatabaseReference) in
            if let _ = error {
                print("aa")
            }
            else{
                self.readCards(uid: uid)
            }
        }
        
        
    }
    
    
//    func removeCard(id: UUID){
//        objectWillChange.send()
////        cards.first(where: $0.id == id)
////        cards.contains(where: {$0.id == id})
//        cards = cards.filter{$0.id != id}
//    }
    
    func removeAllCards(){
        objectWillChange.send()
        cards = []
    }
    
    func getCards() -> [Card] {
        return cards
    }
}
