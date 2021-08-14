//
//  StoreTests.swift
//  FluffySuccotashTests
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Combine
@testable import FluffySuccotash
import XCTest

class StoreTests: XCTestCase {
    var store: Store!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        let initialState = State(regions: [.lisbon, .london, .mumbai],
                                 withinRegion: nil)
        store = Store(initial: initialState,
                      reducer: reducer,
                      middlewares: [])
        cancellables = []
    }

    func testDispatchCheckPermission() throws {
        let expectation = self.expectation(description: "testDispatchCheckPermission")
        expectation.assertForOverFulfill = false
        
        store.$state
            .sink(receiveValue: { newState in
                expectation.fulfill()
            })
            .store(in: &cancellables)

        store.dispatch(.checkPermission)
        
        waitForExpectations(timeout: 1.0)
    }
}
