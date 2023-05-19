//
//  CustomAnnoView.swift
//  Final
//
//  Created by Yuqing Yang on 4/23/23.
//

import SwiftUI
import MapKit
import Firebase

struct CustomAnnoView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var localViewModel: LocationViewModel
    
    var location: Location
    @State private var distance = 1000.0
    @State var ref = Database.database().reference()
    @EnvironmentObject var cards: CardModel
    @State private var cardValue: String = ""
    @State private var cardSuit: String = ""



    var body: some View {
        VStack{
            HStack{
                if(cardSuit == "Diamond") {
                    Image(systemName: "suit.diamond.fill")
                        .foregroundColor(.red)
                }
                else if(cardSuit == "Heart"){
                    Image(systemName: "suit.heart.fill")
                        .foregroundColor(.red)
                }
                else if(cardSuit == "Club"){
                    Image(systemName: "suit.club.fill")
                        .foregroundColor(.black)
                }
                else{
                    Image(systemName: "suit.spade.fill")
                        .foregroundColor(.black)
                }
                
                Text("\(cardValue)")
            }
            
            Text("Latitude: \(localViewModel.locationManager.location!.coordinate.latitude)")
            Text("Longtitude: \(localViewModel.locationManager.location!.coordinate.longitude)")
            Text("Distance: \(localViewModel.locationManager.location!.distance(from: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))) M")
            
            Button(action: {
                
                if(distance<500){
                                    
                    ref.child("global").child(location.id).observeSingleEvent(of: .value, with: { snapshot in
                        let value = snapshot.value as? NSDictionary
                        let name = value?["name"] as? String ?? ""
                        let v = value?["value"] as? String ?? ""
                        let data = ["name": name, "value": v]
                        cards.addCard(data: data)
                        
                    }) { error in
                        print(error.localizedDescription)
                    }
                    ref.child("global").child(location.id).removeValue()
                    NotificationManager.instance.notify()
                    dismiss()
                }
            }, label: {
                Text("Collect")
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding(6)
                    .foregroundColor(distance > 500 ? Color.gray : Color.cyan )
                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.system(size: 20, design: .rounded))
                    .bold()
            })
            .buttonStyle(BStyle())
            .onAppear{
                distance = localViewModel.locationManager.location!.distance(from: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Close")
                    .frame(minWidth: 0, maxWidth: 200)
                    .padding(6)
                    .foregroundColor(Color.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.system(size: 20, design: .rounded))
                    .bold()
            })
            .buttonStyle(BStyle())
        }
        .onAppear{
            ref.child("global").child(location.id).observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let v = value?["value"] as? String ?? ""
                self.cardValue = v
                self.cardSuit = name

            }) { error in
                print(error.localizedDescription)
            }
        }

    }
}

struct CustomAnnoView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAnnoView(location: Location(id:"",name: "d", coordinate: CLLocationCoordinate2D(
            latitude: 10,
            longitude: 10), type: "User"))
    }
}
