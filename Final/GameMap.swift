//
//  GameMap.swift
//  Final
//
//  Created by Yuqing Yang on 3/21/23.
//

import SwiftUI
import MapKit
import Firebase
import CoreLocationUI

struct Location: Identifiable{
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: String
}


struct GameMap: View {
    
    @Binding var tab: Tab
        
    @EnvironmentObject var locationViewModel : LocationViewModel
    
    @StateObject var anno = AnnotationModel()
    
    @StateObject var db = Firebase()
        
    @State private var showSheet = false
        
    @EnvironmentObject var custom: CustomCardModel
    
    @EnvironmentObject var cards: CardModel
    
    @EnvironmentObject var gameModel: GameModel
    
    @State var customCards = [Location]()
    
    @State var c: Int = 0
    
    @State var locations: [Location] = []
    
    @State private var cc: Location?
    
    @State private var id: String = ""
        
    @State private var tracking: MapUserTrackingMode = .follow
    
    @State private var showUser: Bool = true
    
    @State var hide = true
        
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 10,
            longitude: 10),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
    )
    
    var ref = Database.database().reference()

    var body: some View {
        
        VStack{
            if(self.hide == false){
                
                ZStack(alignment: .bottom){
                    ZStack{

                        Map(coordinateRegion: $region, interactionModes: MapInteractionModes.all, showsUserLocation: showUser, userTrackingMode: $tracking ,annotationItems: db.ulocations + custom.customCards, annotationContent: {
                            card in
                            MapAnnotation (coordinate: card.coordinate){
                                Button {
                                    cc = card
                                    showSheet.toggle()
                                    
                                } label: {
                                    Image(card.type == "User" ? "card2" : "card1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(minWidth: 0, maxWidth: 45)
                                        .opacity(0.6)
//                                    Image(systemName: "flag.circle")
//                                        .foregroundColor(card.type == "User" ? .blue : .red)
//                                        .font(.title)
                                }
                                .buttonStyle(BStyle())

                            }
                        })
                        .sheet(item: $cc, content: { l in
                            
                            if(l.type == "User"){
                                CustomAnnoView(location: l)
                                    .environmentObject(custom)
                            }
                            else{
                                AnnotationView(location: l)
                                    .environmentObject(locationViewModel)
                                    .environmentObject(cards)
                                    .environmentObject(anno)
                                    
                            }
                        })
                        .ignoresSafeArea()
                        .accentColor(Color.orange)
                        Circle()
                            .fill(.blue)
                            .frame(width: 32, height: 32)
                            .opacity(custom.place == true ? 0.4 : 0)
                            .zIndex(custom.place == true ? 100 : -1)
                    }
                    .onAppear{

                    }
                    
                    HStack{
                        Button {
                              
                            db.clearCard(uid: id)
                            for _ in 0...9 {
                                let p = 0.02
                                let ran_latitude = Double.random(in: -p...p)
                                let ran_longtitude = Double.random(in: -p...p)
                                
                                let random_name = suit.randomElement()!
                                let random_value = poker.randomElement()!
                                
                                let data: [String:Any] = ["name": random_name, "value":random_value, "latitude": locationViewModel.locationManager.location!.coordinate.latitude+ran_latitude as Double, "longtitude": locationViewModel.locationManager.location!.coordinate.longitude+ran_longtitude as Double, "type":"Random"]
                                
                                db.addCard(uid: id, data: data)
                                                        
                            }
                        } label: {
                            Text("Start")
                                .frame(minWidth: 0, maxWidth: 200)
                                .padding(6)
                                .foregroundColor(.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(40)
                                .font(.system(size: 20, design: .rounded))
                                .bold()
                                .opacity(0.8)
                        }
                        .buttonStyle(BStyle())
                        .onReceive(db.$ulocations){ cc in
                            self.locations = cc
                        }
                        .onReceive(custom.$customCards) { custom in
                            self.customCards = custom
                        }

                        Button {

                            let n = custom.cardContent?.suit ?? ""
                            let v = custom.cardContent?.value ?? ""
                            
                            let data:[String : Any] = ["id": UUID().uuidString, "name": n, "value": v, "latitude": self.region.center.latitude, "longtitude":self.region.center.longitude, "type":"User"]
                            
                            custom.cardContent = nil

                            custom.placeCard(data: data)

                            custom.place = false
                        } label: {
                            Text(custom.place == true ? "Place":"Select")
                                .frame(minWidth: 0, maxWidth: 200)
                                .padding(6)
                                .foregroundColor(.white)
                                .background(custom.place == true ? LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(40)
                                .font(.system(size: 20, design: .rounded))
                                .bold()
                                .opacity(0.8)
                        }
                        .disabled(!custom.place)
                        .buttonStyle(BStyle())
                        
                    }

                }

                .onAppear{

                    self.id = Auth.auth().currentUser?.uid ?? ""
                           
                    db.readCards(uid: id)
                    
                    custom.readCards()
                }
                
            }
        }
        .onAppear{withAnimation {
                self.hide = false
            }
            showUser = true
        }
        .onReceive(locationViewModel.$region){region in
            
            self.region = region
            self.showUser = true
        }
        .onDisappear{
            self.hide = true
        }
        
        
    }
}

struct GameMap_Previews: PreviewProvider {
    static var previews: some View {
        let t = Tab.first
        GameMap(tab: .constant(t))
            .environmentObject(LocationViewModel())
            .environmentObject(GMap())
            .environmentObject(AnnotationModel())
            .environmentObject(CardModel())
    }
}
