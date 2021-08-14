//
//  MockLocationManager.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Combine
import CoreLocation
import Foundation

class MockLocationManager: AnyLocationManager {
    private var regions: [CLRegion]
    private var cancellables: Set<AnyCancellable> = []
    private var currentRegion: CLRegion?
    
    var location: CLLocation?
    
    var locationManagerDelegate: AnyLocationManagerDelegate?
    
    var authorizationStatus: CLAuthorizationStatus
    
    init() {
        regions = []
        authorizationStatus = .notDetermined
        Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .map { _ -> CLRegion? in
                if Bool.random() == true { // Inside or Out of a region
                    return self.regions.randomElement()
                }
                return nil
            }
            .sink(receiveValue: { region in
                if let currentRegion = self.currentRegion {
                    self.locationManagerDelegate?.locationManager(self, didExitRegion: currentRegion)
                }
                self.currentRegion = region
                if let region = region {
                    self.locationManagerDelegate?.locationManager(self,
                                                                  didEnterRegion: region)
                }
            })
            .store(in: &cancellables)
            
    }
    
    func requestWhenInUseAuthorization() {
        authorizationStatus = .authorizedWhenInUse
        
        self.locationManagerDelegate?.locationManagerDidChangeAuthorization(self)
    }
    
    func startMonitoring(for region: CLRegion) {
        regions.append(region)
    }
}
