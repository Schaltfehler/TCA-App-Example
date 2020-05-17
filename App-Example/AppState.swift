//
//  AppState.swift
//  App-Example
//
//  Created by Frederik Vogel on 2020/04/22.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var count = 0
}

enum AppAction: Equatable {
    case countAction(CountAction)
}

struct AppEnvironment: Equatable {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in

    switch action {
    case .countAction(_):
        print("asd")
    }


    return .none
}

// --------------


struct CountState: Equatable {
    var count = 0
}

enum CountAction: Equatable {
    case buttonTapped
}
