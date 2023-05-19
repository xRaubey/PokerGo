////
////  AccountHeaderView.swift
////  Final
////
////  Created by Yuqing Yang on 5/2/23.
////
//
//import SwiftUI
//import Firebase
//
//struct AccountHeaderView: View {
//    
//    @EnvironmentObject var userInfo : UserInfoModel
//    @EnvironmentObject var cards : CardModel
//    var email: String = ""
//    let uid = Auth.auth().currentUser?.uid ?? "unknow_id"
//    @EnvironmentObject var login: LoginModel
//    @EnvironmentObject var gameModel: GameModel
//    
//    
//    var body: some View {
//        
//        
//            Image(uiImage: userInfo.userImage ?? UIImage())
//                .resizable()
//                .cornerRadius(50)
//                .padding(.all, 4)
//                .frame(width: 100, height: 100)
//                .aspectRatio(contentMode: .fill)
//                .clipShape(Circle())
//                .padding(20)
//                .foregroundColor(.white)
//            Text("\(email)")
//                .padding()
//            //            Text("Account \(http.account.account)")
//            //                .padding()
//            Text("Win: 0")
//                .padding()
//            Text("Cards:\(cards.cards.count)")
//                .padding()
//            Button(action: {
//                do {
//                    try Auth.auth().signOut()
//                    gameModel.clearRequest()
//                    //                    gameModel.clearRoom(rid: gameModel.roomId)
//                    login.logOut(uid: uid)
//                }
//                catch {
//                    print("Log out error: \(error)")
//                    return
//                }
//                
//            }, label: {
//                Text("Log Out")
//                    .frame(minWidth: 0, maxWidth: 200)
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
//                    .cornerRadius(40)
//                    .font(.system(size: 20, design: .rounded))
//                    .bold()
//            })
//            .buttonStyle(BStyle())
//        
//        
//    }
//}
//
//struct AccountHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountHeaderView()
//    }
//}
