//
//  Store.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Combine
import Foundation

class Store: ObservableObject {
    @Published private(set) var state: State
    
    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware<State, Action>]
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let queue = DispatchQueue(label: "me.volonbolon.location.store",
                                      qos: .userInitiated)
    
    init(initial state: State,
         reducer: @escaping Reducer<State, Action>,
         middlewares: [Middleware<State, Action>] = []) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }
    
    private func dispatch(_ currentState: State,
                          _ action: Action) {
        let newState = reducer(currentState, action)
        middlewares.forEach { middleware in
            let publisher = middleware(newState, action)
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &cancellables)
                
        }
        self.state = newState
    }
}

