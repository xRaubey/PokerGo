//
//  AnnotationModel.swift
//  Final
//
//  Created by Yuqing Yang on 4/16/23.
//

import Foundation

import Foundation
import SwiftUI
import MapKit


class AnnotationModel: ObservableObject{
    
//    @Published var anno: Location = Location(name: "d", coordinate: CLLocationCoordinate2D(
//        latitude: 10,
//        longitude: 10))
//    
//    @Published var locations: [Location] = []
//    
//    
//    func addLocations(_ location: Location){
//        objectWillChange.send()
//        locations.append(location)
//    }
//    
//    func clearLocations() {
//        locations = []
//    }
//    
//    
//    func update(_ la: Double, _ lo: Double){
//        anno = Location(name: "d", coordinate: CLLocationCoordinate2D(
//            latitude: la,
//            longitude:lo))
//        
//    }
//        
//    func getAnno(id: UUID) -> Location {
//        
//        if let find = locations.first(where: {$0.id == id}) {
//            return find
//        }
//        else{
//            return Location(name: "d", coordinate: CLLocationCoordinate2D(
//                latitude: 10,
//                longitude: 10))
//        }
//    }
//    
//    func deleteLocation(id: UUID) {
//        objectWillChange.send()
//        locations = locations.filter{ $0.id != id }
//    }

//    func contains(_ uf: Int) -> Bool {
//        if(favorites[uf] != nil){
//            return true
//        }
//        else{
//            return false
//        }
//    }
//
//    func add(_ uf: Int, _ m: Movie.Results) {
//        objectWillChange.send()
//        favorites[uf] = m
//    }
//    func remove(_ uf: Int) {
//        objectWillChange.send()
//        favorites[uf] = nil
//    }

}
