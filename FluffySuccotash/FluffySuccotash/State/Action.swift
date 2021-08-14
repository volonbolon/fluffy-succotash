//
//  Action.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import Foundation

enum Action {
    case checkPermission
    case enterRegion(String)
    case leaveRegion(String)
    case loadRegions
    case loadedRegions([Region])
    case requestAuthorization
    case showAuthorizationNotGranted
    case startMonitoringRegions
}
