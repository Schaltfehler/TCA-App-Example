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
    @ObservedObject
    var viewStore: ViewStore<AppState, AppAction>

    init(store: ViewStore<AppState, AppAction>) {
        self.viewStore = store
    }

    var body: some View {
        Button.init(action: {
            self.viewStore.send(.buttonTapped)
        }) {
            Text("Tapped \(viewStore.count) times")
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let appStore = Store.init(initialValue: AppState(),
                                  reducer: appReducer,
                                  environment: AppEnvironment())
        return ContentView(store: appStore.view)
    }
}
