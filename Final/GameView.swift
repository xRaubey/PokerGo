//
//  MatchView.swift
//  Final
//
//  Created by Yuqing Yang on 4/30/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct GameView: View {
    @EnvironmentObject var gameModel: GameModel
    @EnvironmentObject var userInfo: UserInfoModel
    @EnvironmentObject var cards: CardModel
    
    @State var oname: String = ""
    
    @State var rid : String = ""
    
    @State var allCards : [Card] = []
    
    @State var playerCard : String = "Pick Card"
    
    @State var opponentCard: String = "Poker Go"
    
    @State var owins: Int = 0
    
    @State var showResult: Bool = false
    
    @State var result: String = "Unknown result"
    
    @State var v1: Int = 0
    
    @State var v2: Int = 0
    
    @State var disableCards = false
    
    @State var opponentStatue: String = "unknow"
    
    @State var wins: Int = 0
    
//    @State var left: Bool = false
    
    @State var leftMessage: Bool = false
    
    @Environment(\.scenePhase) var scenePhase
    
    var player: String = "unknow"
    
    var uid = Auth.auth().currentUser?.uid ?? "unknow"
    
    var ref = Database.database().reference()
    
    let results = ["You win!", "You lose.", "Draw"]
    
    
    
    var body: some View {
        
        ScrollView{
            HStack{
                RankeView(wins: owins)
                Text(oname)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
            .font(.title)
            .font(.system(size: 20, design: .rounded))
            .bold()
            
            
            HStack{
                VStack{
                    if((opponentCard != "Poker Go" && opponentCard != "pending" && opponentCard != "Pending") && (playerCard == "Pick Card") ){
                        Text("Ready")
                    }
                    else{
                        Text("\(opponentCard)")
                    }
                    
                }
                .frame(width:150, height: 200)
                .foregroundColor(.white)
                .font(.title)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)), Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                .border(.black)
                .cornerRadius(5)
                .padding()

                Spacer()
                Text("VS")
                Spacer()
                VStack{
                    Text("\(playerCard)")
                }
                .frame(width:150, height: 200)
                .foregroundColor(.white)
                .font(.title)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                .border(.black)
                .cornerRadius(5)
                .padding()
            }
                        
            HStack(){
                RankeView(wins: self.wins)
                Text("\(userInfo.userName ?? "unkonw")")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
            .font(.title)
            .font(.system(size: 20, design: .rounded))
            .bold()
            
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 20){
                    ForEach(allCards) { card in
                
                        VStack{
                            CardView(card: card)
                            .frame(minWidth: 0, maxWidth:120)
                            Button {
                                
                                
                                gameModel.pickCard(player: self.player, rid: self.rid, card: card.value)
                                self.playerCard = card.value
                                self.disableCards = true
                            
                                if(poker.contains(playerCard)){
                    
                                    switch playerCard{
                                    case "A":
                                        self.v1 = 14
                                    case "J":
                                        self.v1 = 11
                                    case "Q":
                                        self.v1 = 12
                                    case "K":
                                        self.v1 = 13
                                    default:
                                        self.v1 = Int(playerCard) ?? 0
                                    }

                                }
                                
                            
                                if(poker.contains(opponentCard) && poker.contains(playerCard)){
//                                    print("v1 = \(v1) v2 = \(v2)")
                                    if(v1>v2){
                                        self.result = self.results[0]
                                        gameModel.addWin()
                                    }
                                    else if(v1<v2){
                                        self.result = self.results[1]
                                    }
                                    else{
                                        self.result = self.results[2]
                                    }
                                    
                                    self.showResult = true
                                    self.v1 = 0
                                    self.v2 = 0
                                }
                                
                                cards.removeCard(card: card)
                                
                            } label: {
                                Text("Select")
                            }
                            .disabled(self.disableCards)
                            .frame(width:150)
                            .background(.white)

                        }
                        .frame(width:150, height: 200)
                    }
                }
            }
            .frame(height:200)

            Spacer()
                .frame(height: 30)
            
            Button {
                if(player == "p1"){
                    gameModel.p1LeaveRoom(rid: rid)
                }
                else if(player == "p2"){
                    gameModel.p2LeaveRoom(rid: rid)
                }
                gameModel.gameStart = false
            } label: {
                Text("Leave")
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.system(size: 20, design: .rounded))
                    .bold()
            }
            .buttonStyle(BStyle())
            
        }
        .alert("\(result)",isPresented: $showResult){
            Button("OK", role: .cancel){
                self.opponentCard = "Poker Go"
                self.playerCard = "Pick Card"
                self.v1 = 0
                self.v2 = 0
                self.disableCards = false
                self.result = "Unknown result"
                self.showResult = false
            }
        } message: {
            if(result == self.results[0]){
                Text("Exp +1")
            }
            else{
                Text("Exp +0")
            }
        }
        .alert("The other player left, you win.",isPresented: $leftMessage){
            Button("Cool", role: .cancel){
                self.opponentCard = "Poker Go"
                self.playerCard = "Pick Card"
                self.v1 = 0
                self.v2 = 0
                self.disableCards = true
                self.result = "Unknown result"
                self.showResult = false
                gameModel.addWin()
            }

//            Alert(title: Text("The other player left the game, you win."), dismissButton: .default(Text("Cool")))
        } message: {
            Text("Exp +1")
        }
        .onAppear{
            gameModel.getWins()
        }
        .onReceive(gameModel.$roomId){rid in
//            print("rrid = \(rid)")
            self.rid = rid
            
            gameModel.getPlayerInfo(whichPlayer: player, rid: rid)
            gameModel.getOpponentCard(player: self.player, rid: rid)
        }
        .onReceive(gameModel.$opponentName){ oname in
            self.oname = oname
        }
        .onReceive(gameModel.$opponentWins){ owins in
            
            self.owins = owins
        }
        .onReceive(gameModel.$wins){ wins in
            self.wins = wins
        }
        .onReceive(gameModel.$opponentCard){ ocard in
            self.opponentCard = ocard
        }
        .onReceive(cards.$cards){
            cards in
            self.allCards = cards
        }
        .onReceive(gameModel.$left){ l in
            
            self.disableCards = l
            
        }
        .onChange(of: gameModel.left, perform: { newValue in
//            print("left = \(newValue)")
//            self.left = newValue
//
            if(poker.contains(playerCard) && newValue == true){
                self.leftMessage = true
            }
        })
        
        .onChange(of: opponentCard) { ocard in
            
//            print("ocard = \(ocard)")
            if(poker.contains(ocard)){

                switch ocard{
                case "A":
                    v2 = 14
                case "J":
                    v2 = 11
                case "Q":
                    v2 = 12
                case "K":
                    v2 = 13
                default:
                    v2 = Int(ocard) ?? 0
                }
            }
            
            if(poker.contains(self.playerCard)  && poker.contains(ocard)){
                if(v1 > v2){
                    self.result = self.results[0]
                    gameModel.addWin()
                }
                else if(v1 < v2){
                    self.result = self.results[1]
                }
                else{
                    self.result = self.results[2]
                }

                self.v1 = 0
                self.v2 = 0
                self.showResult = true
                
            }
        }
        .onChange(of: scenePhase){ newValue in
            if(player == "p1"){
                gameModel.p1LeaveRoom(rid: rid)
            }
            else if(player == "p2"){
                gameModel.p2LeaveRoom(rid: rid)
            }
        }
        
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(player: "p1")
    }
}
