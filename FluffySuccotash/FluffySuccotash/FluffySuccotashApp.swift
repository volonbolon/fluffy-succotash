//
//  FluffySuccotashApp.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import SwiftUI

@main
struct FluffySuccotashApp: App {
    func makeStore() -> Store {
        let manager = MockLocationManager()
        let locationService = LocationService(manager: ReactiveLocationManager(manager: manager))
        let apiService = APIService()
        let middlewares: [Middleware<State, Action>] = [
            makeLocationMiddleware(service: locationService),
            makeAPIMiddleware(service: apiService)
        ]
        let store = Store(initial: State(),
                          reducer: reducer,
                          middlewares: middlewares)
        return store
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(makeStore())
        }
    }
}
