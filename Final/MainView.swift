//
//  MainView.swift
//  Final
//
//  Created by Yuqing Yang on 3/22/23.
//

import SwiftUI
import MapKit
import UserNotifications
import Firebase

enum Tab {
    case home
    case first
    case second
    case third
}


struct MainView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var anno : AnnotationModel
    
    @EnvironmentObject var cards : CardModel
    
    @EnvironmentObject var custom : CustomCardModel
    
    @EnvironmentObject var db : Firebase
    
    @EnvironmentObject var userInfo : UserInfoModel
    
    @EnvironmentObject var locationViewModel : LocationViewModel
    
    @EnvironmentObject var gameModel : GameModel
    
    @EnvironmentObject var login: LoginModel
    
    @EnvironmentObject var http:HTTP
    
    @State var selection: Tab = .home
    
    @State var uimage = UIImage(systemName: "person")
    
    @State var username: String = ""
    
    let uid = Auth.auth().currentUser?.uid ?? "unknow"
    
    var body: some View {
        
        VStack{
            if(gameModel.gameStart == true){
                GameView(player: gameModel.player)
                    .environmentObject(cards)
                    .environmentObject(login)
                    .environmentObject(db)
                    .environmentObject(custom)
                    .environmentObject(userInfo)
                    .environmentObject(gameModel)
            }
            else{
                VStack{
                    HStack{
                        Image(uiImage: userInfo.userImage ?? UIImage())
                            .resizable()
                            .cornerRadius(50)
                            .padding(.all, 4)
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                        
                        Text(userInfo.userName ?? "?")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                        
                        Spacer()
                        
                        Button {
                            do {
                                try Auth.auth().signOut()
                                gameModel.clearRequest()
                                login.logOut(uid: uid)
                                
                            }
                            catch {
                                print("Log out error: \(error)")
                                return
                            }
                        } label: {
                            Text("Poker Go")
                                .foregroundColor(.white)
                                .frame(alignment: .centerLastTextBaseline)
                                .padding(.trailing, 20)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 60)
                    
                    TabView(selection: $selection){
                        GameMap(tab: $selection)
                            .tabItem {
                                Image(systemName: "paperplane.fill")
                                Text("Map")
                            }
                            .tag(Tab.home)
                            .environmentObject(cards)
                            .environmentObject(login)
                            .environmentObject(db)
                            .environmentObject(custom)
                            .environmentObject(userInfo)
                            .environmentObject(gameModel)
                        
                        CardGame(tab: $selection)
                            .tabItem {
                                Image(systemName: "gamecontroller.fill")
                                Text("Game")
                            }
                            .tag(Tab.first)
                            .environmentObject(http)
                            .environmentObject(cards)
                            .environmentObject(login)
                            .environmentObject(db)
                            .environmentObject(userInfo)
                            .environmentObject(gameModel)
                        
                        VideoView(tab: $selection)
                            .tabItem {
                                Image(systemName: "video.fill")
                                Text("Video")
                            }
                            .tag(Tab.second)
                            .environmentObject(http)
                            .environmentObject(cards)
                            .environmentObject(login)
                            .environmentObject(db)
                            .environmentObject(custom)
                            .environmentObject(userInfo)
                            .environmentObject(gameModel)
                        
                        AccountView(tab: $selection)
                            .tabItem {
                                Image(systemName: "person.crop.rectangle")
                                Text("Account")
                            }
                            .tag(Tab.third)
                            .environmentObject(http)
                            .environmentObject(cards)
                            .environmentObject(login)
                            .environmentObject(db)
                            .environmentObject(custom)
                            .environmentObject(userInfo)
                            .environmentObject(gameModel)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
                .background(.black)
                .onAppear{
                    
                    NotificationManager.instance.requestAuthorization()
                    http.getAccount();
                    db.readCards(uid: uid)
                    
                }
                .onReceive(userInfo.$userImage){um in
                    if let um = um {
                        self.uimage = um
                    }
                    else{
                        self.uimage = UIImage(systemName: "person")
                    }
                }
                .onChange(of: userInfo.userName ?? "") {newName in
                    self.username = newName
                }
            }

        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .background{
                gameModel.clearRequest()
                login.logOut(uid: uid)
                
            }
        }
    }
    
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(HTTP())
            .environmentObject(AnnotationModel())
            .environmentObject(Firebase())
            .environmentObject(CustomCardModel())
    }
}
