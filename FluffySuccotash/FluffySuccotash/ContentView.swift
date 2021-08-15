//
//  ContentView.swift
//  FluffySuccotash
//
//  Created by Ariel Rodriguez on 14/08/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        ForEach(store.state.regions) { region in
            HStack {
                Text(region.name)
                Image(systemName: store.state.withinRegion == region ? "plus.circle.fill" : "plus.circle")
            }
            .padding()
         }
        .onAppear(perform: {
                store.dispatch(.checkPermission)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let initialState = State()
        let store = Store(initial: initialState, reducer: reducer)
        ContentView()
            .environmentObject(store)
    }
}
