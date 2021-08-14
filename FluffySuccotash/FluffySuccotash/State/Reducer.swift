//
//  Reducer.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Foundation

typealias Reducer<State, Action> = (State, Action) -> State

let reducer: Reducer<State, Action> = { state, action in
    var mutatingState = state
    
    switch action {
    case .loadedRegions(let regions):
        mutatingState.regions = regions
    case .enterRegion(let identifier):
        if let region = mutatingState.regions.first(where: { $0.id == identifier }) {
            mutatingState.withinRegion = region
        }
    case .leaveRegion:
        mutatingState.withinRegion = nil
    default:
        break
    }
    
    return mutatingState
}
