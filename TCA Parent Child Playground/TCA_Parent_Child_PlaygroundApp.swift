//
//  TCA_Parent_Child_PlaygroundApp.swift
//  TCA Parent Child Playground
//
//  Created by Zachary Gibson on 12/17/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCA_Parent_Child_PlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: MainFeature.State()) {
                MainFeature()
                    ._printChanges()
            })
        }
    }
}
