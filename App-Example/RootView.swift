//
//  RootView.swift
//  App-Example
//
//  Created by Freddy on 2020/05/15.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {

    var body: some View {
        TabView {
            CounterView(
                store: Store(
                    initialState: CounterState(),
                    reducer: counterReducer,
                    environment: CounterEnvironment()
                )
            )
                .tabItem {
                    Image(systemName: "1.square")
                    Text("Demo 1")
            }

            MenuView(store:
                Store(initialState: MenuState(),
                      reducer: menuReducer,
                      environment: MenuEnvironment.real
                )
            )
                .tabItem {
                    Image(systemName: "2.square")
                    Text("Demo 2")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        return RootView()
    }
}
