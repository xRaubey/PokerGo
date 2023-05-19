//
//  PlayerCell.swift
//  Final
//
//  Created by Yuqing Yang on 4/28/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct PlayerCell: View {
    
    @EnvironmentObject var userInfo: UserInfoModel
    @EnvironmentObject var cardsInfo: CardModel
    @EnvironmentObject var gameModel: GameModel
    
    @State var image: UIImage? = UIImage()
    @State var fromname: String = ""
    @State var wins: Int = 0
    
    @State var isPresented: Bool = false
    
    @State var roomId: String = ""
    
    @State var hide: Bool = true
    
    var info: UserInfo
    
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    var uid = Auth.auth().currentUser?.uid ?? "unknow"
    
    
    var body: some View {
        VStack{
            if(hide){
                LoadingView()
            }
            else{
                HStack{
                    Image(uiImage: self.image!)
                        .resizable()
                        .cornerRadius(50)
                        .padding(.all, 4)
                        .frame(width: 70, height: 70)
                        .background(Color.white.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(8)
                    RankeView(wins: self.wins)
                    Text(info.username)
                        .frame(maxWidth: 100)
                    Spacer()
                    Button {                        
                        
                        // Send game invitation
                        
                        gameModel.player = "p1"
                        gameModel.createGame(createrId: uid, createrName: userInfo.userName ?? "unknown id", receiverId: info.id)
                        
                        self.isPresented = true
                        
                    } label: {
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: 20)
                            .foregroundColor(.cyan)
//                        Text("Match")
                    }
                    
                }
                .sheet(isPresented: $isPresented){
                    WaitingView(info: info)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .onAppear{
            self.image = UIImage(systemName: "person")
            self.hide = true
            
            let path = ref.child("user").child(info.id).child("account").child("wins")
            path.observe(.value){ snapshot in
                
                self.wins = snapshot.value as? Int ?? 0
            }
            
            let imagePath = storageRef.child("\(info.id)/profile.jpg")
            
            imagePath.getData(maxSize: 5*1024*1024){ data, error in
                if let error = error {
                    print("Image error: ", error)
                } else{
                    self.image = UIImage(data: data!)
                    self.hide = false
                }
            }
        }
    }
    
    
}

struct PlayerCell_Previews: PreviewProvider {
    static var previews: some View {
        PlayerCell(info: UserInfo(id: "0", username: "unknow"))
        
    }
}
