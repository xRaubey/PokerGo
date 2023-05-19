//
//  GameModel.swift
//  Final
//
//  Created by Yuqing Yang on 4/29/23.
//

import Foundation
import Firebase
import FirebaseStorage

class GameModel: ObservableObject{
    
//    @Published var request: [GameRequests] = []
    @Published var requests: [GameRequests] = []
    
    @Published var gameStatus: String = ""
    
    @Published var gameStart: Bool = false
    
    @Published var roomId: String = "unknow room id"
    
    @Published var opponentName: String = "unknow opponent"
    
    @Published var opponentId: String = "unknow opponent id"
    
    @Published var player: String = "unknown p"
    
    @Published var opponentCard: String = "Pending"
    
    @Published var opponentWins: Int = 0
    
    @Published var left : Bool = false
    
    @Published var loginStatus : String = "offline"
    
    @Published var wins: Int = 0

    
    var ref = Database.database().reference()
    
    var id = Auth.auth().currentUser?.uid ?? "unknow"
    
    
    func createGame(createrId: String, createrName: String, receiverId: String){
        
        let roompath = ref.child("matches").childByAutoId()
//        roompath.child("player1").child("name").setValue(createrName)
        roompath.child("player1").setValue(["name": createrName, "card": "pending", "id": id])

        roomId = roompath.key ?? "unknow room"
        
//        roompath.child("player2").child("name").setValue("pending")
        roompath.child("player2").setValue(["name": "pending", "card": "pending", "id": "pending"])
        
        
        let path = ref.child("user").child(receiverId).child("requests").child(createrId)
        path.setValue(["fromid": createrId, "username": createrName, "status": "pending", "room": roomId])
        
    }
    
//    func createRoom(sender: String) {
//        let path = ref.child("matches").childByAutoId().child("player1")
//        path.setValue(sender)
//        roomId = path.key ?? "unknow room"
//    }
    
    func acceptInvit(receiverId: String, receiverName: String, senderId: String) {
        
        let path = ref.child("user").child(receiverId).child("requests").child(senderId).child("room")
        
        path.observeSingleEvent(of: .value, with: { snapshot in


            let roomId = snapshot.value as? String ?? "unkonwn room"
                                print("roomId = \(roomId)")
            self.roomId = roomId
            self.acceptGame(receiverId: receiverId, receiverName: receiverName, senderId: senderId, rid: roomId)
            
//                                print("value = \(snapshot.value!)")
//                                print("room id = \(snapshot.value ?? "unkonwn room")")
        })
        
//        let path = ref.child("user").child(receiverId).child("requests").child("room")
//        path.getData { error, snapshot in
//            guard error == nil else{
//                return
//            }
//            let roomId = snapshot?.value as? String ?? "unkonwn room id"
//            print("room id = \(roomId)")
//            self.roomId = roomId
//        }
    }
    
    func enterRoom(rid: String, receiver: String) {
        let path = ref.child("matches").child(rid).child("player2")
        path.setValue(["name":receiver, "id": id])
    }
    
    func p1LeaveRoom(rid: String){
//        let path = ref.child("matches").child(rid).child("player1")
        let path = ref.child("matches").child(rid)

        path.setValue(nil)
    }
    
    func p2LeaveRoom(rid: String){
//        let path = ref.child("matches").child(rid).child("player2")
        let path = ref.child("matches").child(rid)
        path.setValue(nil)
    }
    
    func clearRoom(rid: String) {
        print("rid = \(rid)")
        let path = ref.child("matches").child(rid)
        path.setValue(nil)
    }
 
    
    
    /**
     Send the game request
     pid: Player ID of the receiver
     id: Player ID of the sender
     */
//    func gameRequest(fromid: String, toid: String, fromname: String) {
//        
//        let path = ref.child("user").child(toid).child("requests").childByAutoId()
//        path.setValue(["fromid": fromid, "username": fromname])
//    }
    
    func observeRequests() {
        let path = ref.child("user").child(id).child("requests")
        path.observe(.value) { snapshot in
            
            var l = [GameRequests]()
//            let request = snapshot.value as? String ?? ""
            let allChildren = snapshot.children.allObjects as? [DataSnapshot] ?? []
            
            for child in allChildren{
                guard let fromId = child.childSnapshot(forPath: "fromid").value as? String else{
                    return
                }
                guard let username = child.childSnapshot(forPath: "username").value as? String else{
                    return
                }
                l.append(GameRequests(id: fromId, username: username))

            }
            self.requests = l
        }
    }
    
//    func observeRequest() {
//        let path = ref.child("user").child(id).child("requests")
//        path.observe(.value) { snapshot in
//
//            var l = [GameRequests]()
////            let request = snapshot.value as? String ?? ""
//            let allChildren = snapshot.children.allObjects as? [DataSnapshot] ?? []
//
//            for child in allChildren{
//                guard let fromId = child.childSnapshot(forPath: "fromid").value as? String else{
//                    return
//                }
//                guard let username = child.childSnapshot(forPath: "username").value as? String else{
//                    return
//                }
//                l.append(GameRequests(id: fromId, username: username))
//            }
//            self.requests = l
//        }
//    }
    
    func clearRequest(){
        let path = ref.child("user").child(id).child("requests")
        path.setValue(nil)
    }
    
    func clearRequestById(uid: String){
        let path = ref.child("user").child(id).child("requests").child(uid)
        path.setValue(nil)
    }
    
    func clearOppoRequestById(uid: String){
        let path = ref.child("user").child(uid).child("requests").child(id)
        path.setValue(nil)
    }
    
    
    func getStatus(receiverId: String, senderId: String) {
        let path = ref.child("user").child(receiverId).child("requests").child(senderId).child("status")
        path.observe(.value) { snapshot in
            
//            print("snapshot = \(snapshot)")
            let status = snapshot.value as? String ?? "unknow"
            self.gameStatus = status
        }
    }
    
    
    func acceptGame(receiverId: String, receiverName: String, senderId: String, rid: String) {
        let path = ref.child("user").child(receiverId).child("requests").child(senderId).child("status")
        path.setValue("accepted")
//        self.clearRequestById(uid: senderId)
        self.clearRequest()
        self.enterRoom(rid: rid, receiver: receiverName)
    }
    
    func rejectGame(receiverId: String, senderId: String) {
        let path = ref.child("user").child(receiverId).child("requests").child(senderId).child("status")
        path.setValue("rejected")
        
        self.clearRequestById(uid: senderId)
    }
    
    func getPlayerInfo(whichPlayer: String, rid: String){
        guard roomId != "" else{
            return
        }
        
        let path: DatabaseReference!
        
        print("self roomid \(self.roomId) rid = \(rid)")
        
        if(whichPlayer == "p1"){
            path = ref.child("matches").child(rid).child("player2")

//            path = ref.child("matches").child(rid).child("player2").child("name")
        }
        else if(whichPlayer == "p2"){
            path = ref.child("matches").child(rid).child("player1")

//            path = ref.child("matches").child(rid).child("player1").child("name")
        }
        else{
            return
        }
        
//        path.observeSingleEvent(of: .value) { snapshot in
//            print("snapshot g = \(snapshot)")
//        }
        
        
        
        path.observe(.value) { snapshot in
            
            if(!snapshot.exists()){
                self.left = true
            }
            else{
                self.left = false
            }
            
            let values = snapshot.value as? NSDictionary
            
           
            self.opponentName = values?["name"] as? String ?? "The player left the game"
            self.opponentId = values?["id"] as? String ?? "unknown opponent"
            
            self.getOppoWins(self.opponentId)
            
            
            
            
//            print("player \(whichPlayer) snapstho = \(snapshot) exists = \(snapshot.exists())")
//
//
//            let playername = snapshot.value as? String ?? "The player left the game"
//
//            print("playername = \(playername)")
////
//            self.opponentName = playername
                        
//            let playername = snapshot.value(forKey: "name") as? String ?? "The player left the game"
//
//            print("playername = \(playername)")
////
//            self.opponentName = playername
//
//            self.opponentId = snapshot.value(forKey: "id") as? String ?? "The player left the game"
            
//            let playername = snapshot.value(forKeyPath: "name")
        }
    }
    
    
    
    func pickCard(player: String, rid: String, card: String) {
        
        var oppo: String
        if(player == "p1" || player == "player1"){
            oppo = "player1"
        }
        else if(player == "p2" || player == "player2"){
            oppo = "player2"
        }
        else{
            oppo = "unknow"
        }
        
        let path = ref.child("matches").child(rid).child(oppo).child("card")
        path.setValue(card)
    }
    
    func getOpponentCard(player: String, rid: String) {
        var oppo: String
        if(player == "p1" || player == "player1"){
            oppo = "player2"
        }
        else if(player == "p2" || player == "player2"){
            oppo = "player1"
        }
        else{
            oppo = "unknow"
        }
        let path = ref.child("matches").child(rid).child(oppo).child("card")
        path.observe(.value) { snapshot in
            let opponentCard = snapshot.value as? String ?? "pending"
            self.opponentCard = opponentCard
        }
    }
    
    func addWin() {
        
        print("abc")
        
        let path = ref.child("user").child(id).child("account").child("wins")
//        path.getData { error, snapshot in
//            guard error == nil else{
//                return
//            }
//            let v = snapshot?.value as? Int ?? 0
//            path.setValue(v + 1)
//        }
        
//        let path = ref.child("user").child(id).child("account").child("wins")
//        path.setValue(100)
        
        path.observeSingleEvent(of: .value) { snapshot in


            if(snapshot.exists()){
                let currentWins = snapshot.value as? Int ?? 0
                let newWins = currentWins + 1
//                snapshot.setValue(newWins, forKey: "wins")
                path.setValue(newWins)
            }
            else{
//                snapshot.setValue(1, forKey: "wins")

                path.setValue(1)
            }
            print("snapshot = \(snapshot) addWin = \(snapshot.value!)")
//            let currentWins = snapshot.value as? Int ?? 0
//            let newWins = currentWins + 1
//            path.setValue(newWins)
        }
    }
    
    func getWins() {
        let path = ref.child("user").child(id).child("account").child("wins")
        path.observe(.value) { snapshot in
            
            self.wins = snapshot.value as? Int ?? 0
//            if(snapshot.exists()){
//                self.wins = snapshot.value as? Int ?? 0
//            }
//            else{
//                path.setValue(0)
//                self.wins = 0
//            }
//            self.wins = snapshot.value as? Int ?? 0
        }
    }
    
    func getOppoWins(_ opid: String) {
        let path = ref.child("user").child(opid).child("account").child("wins")
        path.observe(.value){ snapshot in

            self.opponentWins = snapshot.value as? Int ?? 0
        }
    }
    
//    func getLoginStatus(opponentId: String){
//        let path = ref.child("user").child(opponentId).child("account").child("status")
//        path.observe(.value) { snapshot in
//            self.loginStatus = snapshot.value as? String ?? "offline"
//        }
//    }
//
}
