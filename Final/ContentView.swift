//
//  ContentView.swift
//  Final
//
//  Created by Yuqing Yang on 3/21/23.
//

import SwiftUI
import CoreLocation
import MapKit


struct ContentView: View {
    
//    @StateObject var locationViewModel = LocationViewModel()
//    @StateObject var annotation = AnnotationModel()
    @EnvironmentObject var userInfo : UserInfoModel
    
    @StateObject var anno = AnnotationModel()
    
    @StateObject var cards = CardModel()
    
    @StateObject var custom = CustomCardModel()
    
    @StateObject var db = Firebase()
    
    @StateObject var locationViewModel = LocationViewModel()
    
    @StateObject var gameModel = GameModel()
    
    @EnvironmentObject var login: LoginModel
//    @StateObject var db = Firebase()
    

    
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(locationViewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
                .environmentObject(locationViewModel)
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
                .environmentObject(locationViewModel)
        case .authorizedAlways, .authorizedWhenInUse:
            MainView()

                .environmentObject(anno)
                .environmentObject(cards)
                .environmentObject(login)
                .environmentObject(db)
                .environmentObject(custom)
                .environmentObject(userInfo)
                .environmentObject(gameModel)
                .environmentObject(locationViewModel)

        default:
            Text("Unexpected status")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
