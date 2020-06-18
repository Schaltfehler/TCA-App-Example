//
//  SyncView.swift
//  App-Example
//
//  Created by Freddy on 2020/05/16.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct SyncState: Equatable {
    var count: Int = 0
    var isSyncing: Bool = false
}

enum SyncAction: Equatable {
    case sync
    case syncResponse(Int)
}

struct SyncEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var syncWithServer: (Int) -> Effect<Int, Never>

    static let mock = SyncEnvironment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        syncWithServer: mockSyncWithServer(_:)
    )
}

// There is no server for syncing so lets use this mock for demostration purpose
private func mockSyncWithServer(_ currentCount: Int) -> Effect<Int, Never> {
    return Effect(value: currentCount + Int.random(in: 1...5))
        .delay(for: 5, scheduler: DispatchQueue.main)
        .eraseToEffect()
}


let syncReducer = Reducer<SyncState, SyncAction, SyncEnvironment> { state, action, environment in
    switch action {
    case .sync:
        state.isSyncing = true
        return environment
            .syncWithServer(state.count) // Effect<Int, Never>
            .map( SyncAction.syncResponse ) // create an action with the result; Effect<SyncAction, Never>
            .receive(on: environment.mainQueue)
            .eraseToEffect() // Effect<SyncAction, Never>

    case .syncResponse(let count):
        state.count = count
        state.isSyncing = false
        return .none
    }
}
//.debug()


/// SyncView
/// Sync your counts with the Server

struct SyncView: View {

    let store: Store<SyncFeatureState, SyncFeatureAction>

    // For keeping the SyncState simple, i use a SwiftUI propery wrapper here to keep track of presenting UserSettings.
    // Of cause you can add this state to SyncState as well.
    @State
    var isUserSettingsPresented: Bool = false

    @ObservedObject
    var viewStore: ViewStore<SyncState, SyncAction>

    public init(store: Store<SyncFeatureState, SyncFeatureAction>) {

        self.store = store

        let scopedStore = self.store.scope(state: { (featureState: SyncFeatureState) -> SyncState in
            return SyncState(syncFeatureState: featureState)
        }) { (action: SyncAction) -> SyncFeatureAction in
            SyncFeatureAction(action: action)
        }

        self.viewStore = ViewStore(scopedStore)
    }

    var body: some View {

        VStack {
            ActivityIndicator(isAnimating: viewStore.isSyncing,
                              style: .large)
            Text("Current Count: \(viewStore.count)")
                .font(Font.largeTitle)

            Button("Sync") {
                self.viewStore.send(.sync)
            }
            .disabled(viewStore.isSyncing)
            .font(Font.largeTitle)
        }

        .navigationBarTitle("Sync Count")
        .navigationBarItems(trailing:
            Button("User Settings") {
                self.isUserSettingsPresented.toggle()
            }
            .sheet(isPresented: self.$isUserSettingsPresented) {
                UserSettingsView(store: self.store.scope(
                    state: { UserSettingsState(name: $0.userName) },
                    action: { SyncFeatureAction.userSettings($0) }
                ))
            }
        )
    }
}


extension SyncState {
    init(syncFeatureState: SyncFeatureState) {
        self.isSyncing = syncFeatureState.isSyncing
        self.count = syncFeatureState.count
    }
}

extension SyncFeatureAction {
    init(action: SyncAction) {
        switch action {
        case .sync:
            self = SyncFeatureAction.sync(.sync)
        case .syncResponse(let count):
            self = SyncFeatureAction.sync(.syncResponse(count))
        }
    }
}


#if DEBUG

struct SyncView_Previews: PreviewProvider {
    static var previews: some View {
        SyncView(store:
            Store(initialState: SyncFeatureState(userName: "Someone"),
                  reducer: syncFeatureReducer,
                  environment: SyncFeatureEnvironment.mock
            )
        )
    }
}
#endif
