////
////  GameMap.swift
////  Final
////
////  Created by Yuqing Yang on 3/21/23.
////
//
//import SwiftUI
//import MapKit
//
//struct Location: Identifiable{
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//
//struct GameMap: View {
//    
//    //    @Environment(\.dismiss) private var dismiss
//    //
//    //    @Environment(\.presentationMode) private var dis
//    
//    @EnvironmentObject var locationViewModel: LocationViewModel
//    
//    //    @StateObject var locationViewModel = LocationViewModel()
//    
//    //    @StateObject var gmap = GMap()
//    
////    @State private var locations: [Location] = []
//    
//    @State private var locations = [Location]()
//
//    
//    @State private var showSheet = false
//    
//    
//    //    @EnvironmentObject var anno : AnnotationModel
//    @StateObject var anno = AnnotationModel()
//    
//    
//    
//    //    @State var l: Location =
//    @State private var cc: Location?
//    
//    @State private var a_id: UUID?
//    
//    
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 10,
//            longitude: 10),
//        span: MKCoordinateSpan(
//            latitudeDelta: 0.03,
//            longitudeDelta: 0.03)
//    )
//    
//    
//    //    let cards = [Card(name: "location1", coordinate: CLLocationCoordinate2D(latitude: 30, longitude: -20))]
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            
//            //            Map(coordinateRegion: $region,showsUserLocation: true)
//            
//            
////            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: self.locations, annotationContent: {
////                card in
////                MapAnnotation (coordinate: card.coordinate){
////                    Button {
////                        //                        anno.update(card.coordinate.latitude, card.coordinate.longitude)
////                        //                        a_id = card.id
////
////                        DispatchQueue.main.async {
////                            cc = card
////                            print("\(card.coordinate.latitude)")
////                            showSheet.toggle()
////                        }
////                        //                        cc = card
////                        //                        print("\(card.coordinate.latitude)")
////                        //                        showSheet.toggle()
////
////
////                    } label: {
////                        Image(systemName: "flag.circle")
////                            .foregroundColor(.red)
////                            .font(.title)
////                    }
////                    //                    .sheet(isPresented: $showSheet){
////                    //                        AnnotationView(cardId: card.id ?? UUID())
////                    //                            .environmentObject(anno)
////                    //                    }
////                }
////            })
//            
//            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: self.locations) {
//                card in
//                MapAnnotation (coordinate: card.coordinate){
//                    Text("aa")
////                    Button {
////                        //                        anno.update(card.coordinate.latitude, card.coordinate.longitude)
////                        //                        a_id = card.id
////
//////                        DispatchQueue.main.async {
//////                            cc = card
//////                            print("\(card.coordinate.latitude)")
//////                            showSheet.toggle()
//////                        }
////                                                cc = card
////                                                print("\(card.coordinate.latitude)")
////                                                showSheet.toggle()
////
////
////                    } label: {
////                        Image(systemName: "flag.circle")
////                            .foregroundColor(.red)
////                            .font(.title)
////                    }
//                    //                    .sheet(isPresented: $showSheet){
//                    //                        AnnotationView(cardId: card.id ?? UUID())
//                    //                            .environmentObject(anno)
//                    //                    }
//                }
//            }
////            .sheet(item: $cc, content: { l in
////                AnnotationView(card: l)
////            })
//            .ignoresSafeArea()
//            .accentColor(Color.orange)
////            .onAppear{
////
////                if(locationViewModel.locationManager.location != nil){
////                    locationViewModel.updateRegion(MKCoordinateRegion(center: locationViewModel.locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)))
////                    //                    locationViewModel.region = MKCoordinateRegion(center: locationViewModel.locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
////                }
////                else{
////                    let c = CLLocationCoordinate2D(
////                        latitude: 0,
////                        longitude: 0)
////                    locationViewModel.updateRegion(MKCoordinateRegion(center: c, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)))
////                    //                    locationViewModel.region = MKCoordinateRegion(center: c, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
////                }
////
////            }
//            
//            
//            //            Map(coordinateRegion: $locationViewModel.region, showsUserLocation: true)
//            //                .ignoresSafeArea()
//            //                .accentColor(Color(.systemRed))
//            //                .onAppear{
//            //
//            //                    if(locationViewModel.locationManager.location != nil){
//            //                        locationViewModel.region = MKCoordinateRegion(center: locationViewModel.locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
//            //                    }
//            //                    else{
//            //                        let c = CLLocationCoordinate2D(
//            //                                        latitude: 0,
//            //                                        longitude: 0)
//            //                        locationViewModel.region = MKCoordinateRegion(center: c, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
//            //                    }
//            //
//            //                }
//            HStack{
//                Button {
//                    
//                    //
//                    //                    let p = 0.02
//                    //                                                let ran_latitude = Double.random(in: -p...p)
//                    //                                                let ran_longtitude = Double.random(in: -p...p)
//                    //                    locations = [Location(name: "location1", coordinate: CLLocationCoordinate2D(
//                    //                        latitude: locationViewModel.locationManager.location!.coordinate.latitude+ran_latitude,
//                    //                        longitude: locationViewModel.locationManager.location!.coordinate.longitude+ran_longtitude)),
//                    //                                 Location(name: "location1", coordinate: CLLocationCoordinate2D(
//                    //                                     latitude: locationViewModel.locationManager.location!.coordinate.latitude+ran_latitude,
//                    //                                     longitude: locationViewModel.locationManager.location!.coordinate.longitude+ran_longtitude))]
//                    //
//                    //
//                    DispatchQueue.main.async{
////                        anno.clearLocations()
//                        let p = 0.02
//                        let ran_latitude = Double.random(in: -p...p)
//                        let ran_longtitude = Double.random(in: -p...p)
//                        let nl = Location(name: "location1", coordinate: CLLocationCoordinate2D(
//                            latitude: ran_latitude,
//                            longitude: ran_longtitude))
//                        locations.append(nl)
//                        //                        anno.addLocations(la: region.center.longitude+ran_latitude, lo: region.center.longitude+ran_longtitude)
//                        
//                        //                        for _ in 0...9 {
//                        //                            let p = 0.02
//                        //                            let ran_latitude = Double.random(in: -p...p)
//                        //                            let ran_longtitude = Double.random(in: -p...p)
//                        //                            anno.addLocations(Location(name: "location1", coordinate: CLLocationCoordinate2D(
//                        //                                latitude: locationViewModel.locationManager.location!.coordinate.latitude+ran_latitude,
//                        //                                longitude: locationViewModel.locationManager.location!.coordinate.longitude+ran_longtitude)))
//                        //                        }
//                    }
//                    
//                    
//                    //                    locations = []
//                    //                    for _ in 0...9 {
//                    //                        let p = 0.02
//                    //                        let ran_latitude = Double.random(in: -p...p)
//                    //                        let ran_longtitude = Double.random(in: -p...p)
//                    //                        locations.append( Location(name: "location1", coordinate: CLLocationCoordinate2D(
//                    //                            latitude: locationViewModel.locationManager.location!.coordinate.latitude+ran_latitude,
//                    //                            longitude: locationViewModel.locationManager.location!.coordinate.longitude+ran_longtitude))
//                    //                        )
//                    //                    }
//                    
//                } label: {
//                    Text("Start")
//                }
//                .padding()
//                .foregroundColor(.orange)
//                .border(Color.orange, width: 2)
//                .fontWeight(.bold)
////                .onReceive(anno.$locations) { locations in
////                    self.locations = locations
////                }
//                
//                Button {
//                    //print("aaa")
//                } label: {
//                    Text("Find")
//                }
//                .padding()
//                .foregroundColor(.blue)
//                .border(Color.blue, width: 2)
//                .fontWeight(.bold)
//                
//                //                Text("\(coordinate?.latitude ?? 0)")
//                
//            }
//            //            .sheet(isPresented: $showSheet){
//            //
//            //                Text("\(anno.getAnno(id: a_id ?? UUID()).coordinate.longitude)")
//            ////                AnnotationView(cardId: a_id ?? UUID())
//            ////                    .environmentObject(anno)
//            //            }
//            
//            //            .sheet(item: $cc, content: { l in
//            //                AnnotationView(card: l)
//            //            })
//            //            .sheet(item: $cc) { l in
//            ////                AnnotationView(card: l)
//            //                VStack{
//            //                    Text("Lontitude: \(l.coordinate.longitude)")
//            //                    Text("Latitude: \(l.coordinate.latitude)")
//            //                    Button("Close"){
//            //                        print("dis")
//            //                        dismiss()
//            //                    }
//            //                    .foregroundColor(Color.cyan)
//            //                }
//            //            }
//            
//        }
//        .onAppear{
//            region = locationViewModel.region
//        }
//        //        .onReceive(locationViewModel.region) { region in
//        //            self.region = region
//        //        }
//        
//        
//        //        .sheet(item: $cc){ p in
//        //
//        //            Text("\(anno.getAnno().coordinate.longitude)")
//        ////            AnnotationView(card: anno.getAnno())
//        //            //            AnnotationView(card: String(locations[0].coordinate.longitude))
//        //        }
//        
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    var coordinate: CLLocationCoordinate2D? {
//        locationViewModel.lastSeenLocation?.coordinate
//    }
//    
//    
//}
//
//struct GameMap_Previews: PreviewProvider {
//    static var previews: some View {
//        GameMap()
//            .environmentObject(LocationViewModel())
//            .environmentObject(GMap())
//            .environmentObject(AnnotationModel())
//    }
//}
