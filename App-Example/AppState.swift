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
    case buttonTapped
}

struct AppEnvironment: Equatable {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in

    switch action {
    case .buttonTapped:
        state.count += 1
    }


    return .none
}

