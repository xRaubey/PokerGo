//
//  RealLocation.swift
//  Final
//
//  Created by Yuqing Yang on 3/21/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    @Published var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 10,
            longitude: 10),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
    )
    
    
    let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.4
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastSeenLocation = locations.first else{
            return
        }
        fetchCountryAndCity(for: locations.first)
        DispatchQueue.main.async {
            
            self.region = MKCoordinateRegion(center: lastSeenLocation.coordinate, span: MKCoordinateSpan(
                latitudeDelta: 0.03,
                longitudeDelta: 0.03))
        }
    }
    
    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.currentPlacemark = placemarks?.first
        }
    }
    
    func updateRegion() {
        objectWillChange.send()
        print("update region")
        if(self.locationManager.location != nil){
            self.region = MKCoordinateRegion(center: self.locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        }
        else{
            let c = CLLocationCoordinate2D(
                latitude: 0,
                longitude: 0)
            self.region = MKCoordinateRegion(center: c, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        }
//        print("region = \(self.region)")
    }
    
//    func upadteLocation() -> MKCoordinateRegion{
//        region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
//        return region
//    }
    
}
