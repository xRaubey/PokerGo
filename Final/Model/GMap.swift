//
//  Map.swift
//  Final
//
//  Created by Yuqing Yang on 4/11/23.
//

import Foundation

class GMap: ObservableObject{
    @Published var annotations: [Int:(Double,Double)] = [:]
    
    init() {
    
    }
    
    func addAnnotation(id: Int, location: (Double,Double)) {
        objectWillChange.send()
        annotations[id] = location
    }
    
    func removeAnnotation(id: Int) {
        objectWillChange.send()
        annotations[id] = nil
    }
    
    func checkAnnotation(id: Int) -> Bool {
        if let _ = annotations[id]{
            return true
        }
        else{
            return false
        }
    }
    
    
}
