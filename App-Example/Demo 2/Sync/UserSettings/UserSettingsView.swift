//
//  UserSettingsView.swift
//  App-Example
//
//  Created by Freddy on 2020/06/11.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct UserSettingsState: Equatable {
    var name = ""
}

enum UserSettingsAction: Equatable {
    case changeName(String)
}

struct UserSettingsEnvironment { }


let userSettingsReducer = Reducer<UserSettingsState, UserSettingsAction, UserSettingsEnvironment> { state, action, environment in
    switch action {
    case let .changeName(name):
        state.name = name
        return .none
    }
}
//.debug()


/// UserSettingsView
/// Update your Username

struct UserSettingsView: View {
    
    let store: Store<UserSettingsState, UserSettingsAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading) {
                    Text("Current user:")
                        .font(Font.largeTitle)
                    
                    TextField(
                        "User Name",
                        text: viewStore.binding(
                            get: { $0.name },
                            send: { UserSettingsAction.changeName($0) }
                        )
                    )
                        .font(Font.largeTitle)
                    
                    Spacer()
                }
                .padding(.init(top: 0, leading: 20, bottom: 100, trailing: 20))
                .navigationBarTitle("User Settings")
            }
        }
    }
}

#if DEBUG

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(store:
            Store(initialState: UserSettingsState(name: "Freddy"),
                  reducer: userSettingsReducer,
                  environment: UserSettingsEnvironment()
            )
        )
    }
    
}
#endif
