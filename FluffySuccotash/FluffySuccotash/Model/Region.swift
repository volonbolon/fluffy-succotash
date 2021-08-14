//
//  Region.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import CoreLocation
import Foundation

struct Region: Identifiable {
    let id: String
    let name: String
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
    
    static let mumbai: Region = {
        Region(id: UUID().uuidString,
               name: "Mumbai",
               center: CLLocationCoordinate2D(latitude: 19.0761, longitude: 72.8774),
               radius: 1000)
    }()
    
    static let lisbon: Region = {
        Region(id: UUID().uuidString,
               name: "Lisbon",
               center: CLLocationCoordinate2D(latitude: 38.7370, longitude: -9.1427),
               radius: 1000)
    }()
    
    static let london: Region = {
        Region(id: UUID().uuidString,
               name: "London",
               center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1364),
               radius: 1000)
    }()
}

extension Region: Equatable {
    static func == (lhs: Region, rhs: Region) -> Bool {
        lhs.id == rhs.id
    }
}

