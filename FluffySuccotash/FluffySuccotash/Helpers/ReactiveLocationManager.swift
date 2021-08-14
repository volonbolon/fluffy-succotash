//
//  ReactiveLocationManager.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Combine
import CoreLocation
import Foundation

enum ShiftRegionInfo {
    case enter(String)
    case exit(String)
}

protocol AnyReactiveLocationManager: CLLocationManagerDelegate {
    func authorization() -> AnyPublisher<CLAuthorizationStatus, Never>
    func currentLocation() -> AnyPublisher<[CLLocation], Never>
    func requestAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never>
    func startMonitoringRegions(_ regions: [Region]) -> AnyPublisher<ShiftRegionInfo, Never>
}

