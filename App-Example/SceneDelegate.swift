//
//  SceneDelegate.swift
//  App-Example
//
//  Created by Frederik Vogel on 2020/04/21.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let appStore = Store(initialState: AppState(),
                             reducer: appReducer,
                             environment: AppEnvironment())

        let rootView = RootView(store: appStore)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: rootView)
        self.window = window
        window.makeKeyAndVisible()
    }
}

