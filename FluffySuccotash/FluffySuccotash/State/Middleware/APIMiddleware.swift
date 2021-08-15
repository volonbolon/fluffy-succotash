//
//  APIMiddleware.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Combine
import Foundation

// A real app, would have an API service adopting
// this protocol to retrieve regions from network
protocol AnyAPIService {
    func retrieveRegions() -> AnyPublisher<[Region], Never>
}

class APIService: AnyAPIService {
    func retrieveRegions() -> AnyPublisher<[Region], Never> {
        Future<[Region], Never> { promise in
            let regions = [
                Region.london,
                Region.mumbai,
                Region.lisbon
            ]
            promise(.success(regions))
        }
        .eraseToAnyPublisher()
    }
}

func makeAPIMiddleware(service: AnyAPIService) -> Middleware<State, Action> {
    return { state, action in
        switch action {
        case .loadRegions:
            return service.retrieveRegions()
                .subscribe(on: DispatchQueue.main)
                .map { regions in
                    .loadedRegions(regions)
                }
                .eraseToAnyPublisher()
        default:
            return Empty()
                .eraseToAnyPublisher()
        }
    }
}
