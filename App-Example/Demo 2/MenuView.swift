//
//  MenuView.swift
//  App-Example
//
//  Created by Freddy on 2020/05/16.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct MenuState: Equatable {

    var count: Int = 0
    var isSyncing: Bool = false

    var countState: CountUpState {
        get {
            CountUpState(isSyncing: self.isSyncing,
                         count: self.count)
        }
        set {
            self.count = newValue.count
            self.isSyncing = newValue.isSyncing
        }
    }

    var syncState: SyncState {
        get {
            SyncState(count: self.count,
                      isSyncing: self.isSyncing)
        }
        set {
            self.count = newValue.count
            self.isSyncing = newValue.isSyncing
        }
    }
    
}

enum MenuAction: Equatable {
    case count(CountUpAction)
    case sync(SyncAction)
}

struct MenuEnvironment {
    let countUpEnvironment: CountUpEnvironment
    let syncEnvironment: SyncEnvironment

    static let real = MenuEnvironment(countUpEnvironment: CountUpEnvironment(),
    syncEnvironment: SyncEnvironment.mock)
}


let menuReducer = Reducer<MenuState, MenuAction, MenuEnvironment>
    .combine(
        countUpReducer.pullback(
            state: \MenuState.countState,
            action: /MenuAction.count,
            environment: { $0.countUpEnvironment }
        ),
        syncReducer.pullback(
            state: \MenuState.syncState,
            action: /MenuAction.sync,
            environment: { $0.syncEnvironment }
        )
)


struct MenuView: View {

    let store: Store<MenuState, MenuAction>

    var body: some View {

        NavigationView {
            List {
                NavigationLink("Count",
                               destination:
                    CountUpView(store:
                        // scope into MenuState.countState
                        self.store.scope(state: { $0.countState },
                                         action: MenuAction.count)
                    )
                )
                NavigationLink("Sync",
                               destination:
                    SyncView(store:
                        self.store.scope(state: { $0.syncState },
                                         action: MenuAction.sync)
                    )
                )
            }
            .navigationBarTitle("People Count App")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(store: Store(initialState: MenuState(),
                              reducer: menuReducer,
                              environment: MenuEnvironment.real))
    }
}
