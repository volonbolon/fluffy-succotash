//
//  CLLocationManager+Combine.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Combine
import CoreLocation
import Foundation

class ReactiveLocationManager: NSObject {
    var manager: AnyLocationManager
    
    let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    let regionSubject = PassthroughSubject<ShiftRegionInfo, Never>()
    
    init(manager: AnyLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.manager.locationManagerDelegate = self
    }
}

extension ReactiveLocationManager: AnyReactiveLocationManager {
    func authorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        Just(manager.authorizationStatus)
            .merge(with: authorizationSubject.compactMap { $0 })
            .eraseToAnyPublisher()
    }
    
    func requestAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        manager.requestWhenInUseAuthorization()
        
        return authorizationSubject
            .eraseToAnyPublisher()
    }
    
    func currentLocation() -> AnyPublisher<[CLLocation], Never> {
        Empty()
            .eraseToAnyPublisher()
    }
    
    func startMonitoringRegions(_ regions: [Region]) -> AnyPublisher<ShiftRegionInfo, Never> {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            return Just(.exit(""))
                .eraseToAnyPublisher()
        }
        _ = regions.map { region in
            let circularRegion = CLCircularRegion(center: region.center,
                                                  radius: region.radius,
                                                  identifier: region.id)
            manager.startMonitoring(for: circularRegion)
        }
        return regionSubject
            .eraseToAnyPublisher()
    }
}

extension ReactiveLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationManagerDidChangeAuthorization(manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.locationManager(manager,
                             didEnterRegion: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.locationManager(manager, didEnterRegion: region)
    }
}

extension ReactiveLocationManager: AnyLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: AnyLocationManager) {
        authorizationSubject
            .send(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: AnyLocationManager,
                         didEnterRegion region: CLRegion) {
        regionSubject
            .send(.enter(region.identifier))
    }
    
    func locationManager(_ manager: AnyLocationManager,
                         didExitRegion region: CLRegion) {
        regionSubject
            .send(.exit(region.identifier))
    }
}
