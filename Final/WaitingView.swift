//
//  GameView.swift
//  Final
//
//  Created by Yuqing Yang on 4/29/23.
//

import SwiftUI
import Firebase

struct WaitingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userInfo: UserInfoModel
    @EnvironmentObject var gameModel: GameModel
    
    @State var status = "unknow"
    @State var disableDrage = true
    @State var disableEnd = false
    @State var roomId = ""
    
    var info: UserInfo
    var uid = Auth.auth().currentUser?.uid ?? "unknow"
    
    var ref = Database.database().reference()
    
    var body: some View {
        NavigationView{
            VStack{
                if(status == "unknow"){
                    Text("Rejected")
                        .padding()
                        .font(.title2)
                }
                else if(status == "accepted"){
                    Text("Accepted")
                        .padding()
                        .font(.title2)
                }
                else if(status == "rejected"){
                    Text("Rejected")
                        .padding()
                        .font(.title2)
                }
                else{
                    Text("Pending...")
                        .padding()
                        .font(.title2)
                }
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("OK")
                        .frame(minWidth: 0, maxWidth: 80)
                        .padding()
                        .foregroundColor(.white)
                        .background(disableEnd ?
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                    :
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(40)
                        .font(.system(size: 20, design: .rounded))
                        .bold()
                })
                .buttonStyle(BStyle())
                .disabled(disableEnd)
                
                Button(action: {
                    print("rrrr = \(self.roomId) uid = \(info.id)")
                    gameModel.clearOppoRequestById(uid: info.id)
                    gameModel.p1LeaveRoom(rid: self.roomId)
                    dismiss()
                }, label: {
                    Text("Leave")
                        .frame(minWidth: 0, maxWidth: 80)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .font(.system(size: 20, design: .rounded))
                        .bold()
                })
                .buttonStyle(BStyle())
            }
        }
        .interactiveDismissDisabled()
        .onAppear{
            print("waiting shows")
            gameModel.getStatus(receiverId: info.id, senderId: uid)
                        
        }
        .onReceive(gameModel.$roomId){roomId in
            self.roomId = roomId
        }
        .onReceive(gameModel.$gameStatus){ status in
            print("status = \(status)")
            self.status = status
        }
        .onChange(of: status) { newValue in
            if(newValue == "pending"){
                disableEnd = true
                disableDrage = true
            }
            else if(newValue == "accepted"){
                disableEnd = false
                disableDrage = false
                dismiss()
                gameModel.gameStart = true
            }
            else if(newValue == "rejected"){
                disableEnd = false
                disableDrage = false
                gameModel.clearRoom(rid: gameModel.roomId)
            }
            else{
                disableEnd = false
                disableDrage = false
            }
        }
    }
}

struct Waiting_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView(info: UserInfo(id: "0", username: "unknow"))
    }
}
