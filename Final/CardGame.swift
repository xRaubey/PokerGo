//
//  CardGame.swift
//  Final
//
//  Created by Yuqing Yang on 3/21/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct UserInfo: Identifiable, Hashable{
    let id: String  // user id
    let username: String
    //    let image: UIImage
}

struct GameRequests: Identifiable, Hashable{
    let id: String // from id
    let username: String
}

struct CardGame: View {
    
    @Binding var tab: Tab
    
    
    @EnvironmentObject var userInfo: UserInfoModel
    @EnvironmentObject var cardsInfo: CardModel
    @EnvironmentObject var gameModel: GameModel
    
    @State var allUsers: [UserInfo] = []
    @State var count: Int = 0
    @State var requests: [GameRequests] = []
    
    @State var receiver: String = ""
        
    @State var timer: Bool = false
    
    @State var notificate: Bool = false
        
    @State var cc: UserInfo = UserInfo(id: "0", username: "unkonw")
    
    @State private var search: String = ""
    
    
    
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    var uid = Auth.auth().currentUser?.uid ?? "unknow"
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            VStack{
                
                if(self.count <= 0){
                    Text("You don't have enough cards.")
                        .padding()
                }
                else{
                    List{
                        Section(header: Text("Online Players")){
                            ForEach(allUsers){info in
                                if(info.id != uid){
                                    PlayerCell(info: info)
                                        .environmentObject(userInfo)
                                        .environmentObject(cardsInfo)
                                }
                            }
                        }
                    }
                    .searchable(text: $search)
                }
                
            }
            
            if(self.requests.count>0){
                
                ForEach(requests){ request in
                    HStack{
                        Text("Game request from \(request.username)")
                            .padding(.leading, 20)
                        Spacer()
                        Button {
                            
                            gameModel.acceptInvit(receiverId: uid, receiverName: userInfo.userName ?? "unknow receiver", senderId: request.id)
                            gameModel.player = "p2"
                            gameModel.gameStart = true
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .padding()
                        }
                        Button {
                            gameModel.rejectGame(receiverId: uid, senderId: request.id)
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .background(.black)
                    .foregroundColor(.white)
                    
                }
                .opacity(0.7)
            }
        }
        .onAppear{
            cardsInfo.readCards(uid: uid)
            userInfo.getAllUsers()
            gameModel.observeRequests()
        }
        .onReceive(cardsInfo.$cards){ count in
            self.count = count.count
        }
        .onReceive(userInfo.$allUsers){ allusers in
            self.allUsers = allusers ?? []
        }
        .onReceive(gameModel.$requests){requests in
            
            if(self.requests != requests){

                if(requests.count > 0 && self.requests.count <= 0){
                    NotificationManager.instance.notify2(title: "Game Invitation", subtitle: "You have game invitations")
                }
                self.requests = requests
            }
            
        }
    }
    
}

struct CardGame_Previews: PreviewProvider {
    static var previews: some View {
        let t = Tab.first
        CardGame(tab: .constant(t))
            .environmentObject(HTTP())
//        CardGame(isPresented: false)
//            .environmentObject(HTTP())
    }
}
