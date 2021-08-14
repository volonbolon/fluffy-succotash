//
//  ReducerTests.swift
//  FluffySuccotashTests
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

@testable import FluffySuccotash
import XCTest

class ReducerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadRegions() {
        let state = State(regions: [],
                          withinRegion: nil)
        let newState = reducer(state, .loadedRegions([.lisbon, .london]))
        XCTAssertEqual(newState.regions.first!, .lisbon)
        XCTAssertEqual(newState.regions.last!, .london)
        XCTAssertNil(newState.withinRegion)
    }
    
    func testEnterRegion() {
        let state = State(regions: [.lisbon, .london, .mumbai],
                          withinRegion: nil)
        let newState = reducer(state, .enterRegion(Region.london.id))
        XCTAssertEqual(newState.withinRegion, .london)
    }
    
    func testLeaveRegion() {
        let state = State(regions: [.lisbon, .london, .mumbai],
                          withinRegion: Region.london)
        let newState = reducer(state, .leaveRegion(Region.london.id))
        XCTAssertNil(newState.withinRegion)
    }
}
