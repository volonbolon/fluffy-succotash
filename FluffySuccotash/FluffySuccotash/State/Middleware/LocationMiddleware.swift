//
//  LocationMiddleware.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Combine
import CoreLocation
import Foundation

class LocationService {
    let manager: AnyReactiveLocationManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(manager: AnyReactiveLocationManager) {
        self.manager = manager
    }
    
    func retrievePermission() -> AnyPublisher<CLAuthorizationStatus, Never> {
        self.manager.authorization()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestAuthorization() -> AnyPublisher<CLAuthorizationStatus, Never> {
        Future<CLAuthorizationStatus, Never> { promise in
            self.manager.requestAuthorization()
                .receive(on: DispatchQueue.main)
                .sink { status in
                    promise(.success(status))
                }
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func startMonitoringRegions(_ regions: [Region]) -> AnyPublisher<ShiftRegionInfo, Never> {
        self.manager.startMonitoringRegions(regions)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

func makeLocationMiddleware(service: LocationService) -> Middleware<State, Action> {
    return { state, action in
        switch action {
        case .checkPermission:
            return service.retrievePermission()
                .subscribe(on: DispatchQueue.main)
                .map { status in
                    switch status {
                    case .notDetermined:
                        return .requestAuthorization
                    case .authorizedAlways, .authorizedWhenInUse:
                        return .loadRegions
                    case .denied, .restricted:
                        return .showAuthorizationNotGranted
                    @unknown default:
                        fatalError()
                    }
                }
                .eraseToAnyPublisher()
        case .loadedRegions(let regions):
            return service.startMonitoringRegions(regions)
                .subscribe(on: DispatchQueue.main)
                .map({ info in
                    switch info {
                    case .enter(let identifier):
                        return .enterRegion(identifier)
                    case .exit(let identifier):
                        return .leaveRegion(identifier)
                    }
                })
                .print()
                .eraseToAnyPublisher()
        case .requestAuthorization:
            return service.requestAuthorization()
                .subscribe(on: DispatchQueue.main)
                .map { status in
                    switch status {
                    case .authorizedAlways, .authorizedWhenInUse:
                        return .loadRegions
                    default:
                        return .showAuthorizationNotGranted
                    }
                }
                .eraseToAnyPublisher()
        default:
            return Empty()
                .eraseToAnyPublisher()
        }
    }
}
