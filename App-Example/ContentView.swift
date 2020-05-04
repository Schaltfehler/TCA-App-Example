//
//  ContentView.swift
//  App-Example
//
//  Created by Frederik Vogel on 2020/04/21.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

    let store: Store<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.buttonTapped)
            }) {
                Text("Tapped \(viewStore.count) times")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let appStore = Store(initialState: AppState(),
                             reducer: appReducer,
                             environment: AppEnvironment())
        return ContentView(store: appStore)
    }
}
