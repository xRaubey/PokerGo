//
//  AccountView.swift
//  Final
//
//  Created by Yuqing Yang on 3/31/23.
//

import SwiftUI
import Firebase

struct AccountView: View {
    
    @Binding var tab: Tab
    
    @EnvironmentObject var http: HTTP
    
    @StateObject var cards = CardModel()
    
//    @EnvironmentObject var cards: CardModel
    
    @State var allCards: [Card] = []
    
    @EnvironmentObject var login: LoginModel
    
    @EnvironmentObject var custom: CustomCardModel
    
    @EnvironmentObject var gameModel: GameModel
    
    @EnvironmentObject var userInfo: UserInfoModel

    @State var isLoggedIn: Bool = false
    
    @State var email: String = ""
    
    @State var wins: Int = 0
    
    let uid = Auth.auth().currentUser?.uid ?? "unknow_id"
    
    
    var body: some View {
        
        VStack{
            
            List{
                Section{
                    Image(uiImage: userInfo.userImage ?? UIImage())
                        .resizable()
                        .cornerRadius(50)
                        .padding(.all, 4)
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(20)
                        .foregroundColor(.white)
                    Text("\(email)")
                        .padding()
                    HStack{
                        RankeView(wins: self.wins)
                        Text("\(self.wins)")
                            .padding()
                    }
                    
                    HStack{
                        Image("cards")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding()
                        Text("\(allCards.count)")
                            .padding()
                    }
                    
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            gameModel.clearRequest()
                            login.logOut(uid: uid)
                        }
                        catch {
                            print("Log out error: \(error)")
                            return
                        }

                    }, label: {
                        Text("Log Out")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .font(.system(size: 20, design: .rounded))
                            .bold()
                    })
                    .buttonStyle(BStyle())
                }
                
                
                ForEach(self.allCards){ card in
                    HStack{
                        if(card.name == "Diamond") {
                            Image(systemName: "suit.diamond.fill")
                                .foregroundColor(.red)
                        }
                        else if(card.name == "Heart"){
                            Image(systemName: "suit.heart.fill")
                                .foregroundColor(.red)
                        }
                        else if(card.name == "Club"){
                            Image(systemName: "suit.club.fill")
                                .foregroundColor(.black)
                        }
                        else{
                            Image(systemName: "suit.spade.fill")
                                .foregroundColor(.black)
                        }
                        Text("\(card.value)")
                    }
                    
                        .padding()
                        .swipeActions{
                            Button("GO!"){
                                custom.place = true
                                custom.cardContent = cardContent(suit: card.name, value: card.value)
                                cards.removeCard(card: card)

                                self.tab = .home
                            }
                            .tint(.blue)
                            
//                            Button("Trade"){
//                            }
//                            .tint(.green)
                            
                            Button("Delete"){
                                cards.removeCard(card: card)

                            }
                            .tint(.red)
                        }
                }

            }
        }
        .background(Color.cyan)
        .onReceive(cards.$cards){
            cards in
            self.allCards = cards
        }
        .onAppear{
            guard let id = Auth.auth().currentUser?.uid else{
                return
            }
            Auth.auth().addStateDidChangeListener{ auth, user in
                if let user = user {
                    email = user.email ?? ""
                }
            }
            
            cards.readCards(uid: id)
            
            gameModel.getWins()
        }
        .onReceive(gameModel.$wins){ wins in
            self.wins = wins
        }
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let t = Tab.third
        AccountView(tab: .constant(t))
            .environmentObject(HTTP())
            .environmentObject(CardModel())
    }
}
