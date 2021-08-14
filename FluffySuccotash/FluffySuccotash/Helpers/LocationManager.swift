//
//  LocationManager.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import CoreLocation
import Foundation

protocol AnyLocationManagerDelegate: AnyObject {
    func locationManagerDidChangeAuthorization(_ manager: AnyLocationManager)
    func locationManager(_ manager: AnyLocationManager,
                         didEnterRegion region: CLRegion)
    func locationManager(_ manager: AnyLocationManager,
                         didExitRegion region: CLRegion)
}

protocol AnyLocationManager {
    var location: CLLocation? { get }
    var locationManagerDelegate: AnyLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func startMonitoring(for region: CLRegion)
}

extension CLLocationManager: AnyLocationManager {
    var locationManagerDelegate: AnyLocationManagerDelegate? {
        get {
            return delegate as! AnyLocationManagerDelegate?
        }
        
        set {
            delegate = newValue as! CLLocationManagerDelegate?
        }
    }
}

