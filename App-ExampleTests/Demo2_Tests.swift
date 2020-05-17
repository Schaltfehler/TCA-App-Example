//
//  Demo2_Tests.swift
//  App-ExampleTests
//
//  Created by Freddy on 2020/05/17.
//  Copyright © 2020 Frederik Vogel. All rights reserved.
//

import XCTest
import ComposableArchitecture
@testable import App_Example

class Demo2_Tests: XCTestCase {

    func testCountUp() {
        let store = TestStore(
            initialState: CountUpState(isSyncing: false, count: 0),
            reducer: countUpReducer,
            environment: CountUpEnvironment()
        )

        store.assert(
            .send(.countUp) {
                $0.count = 1
            },
            .send(.countUp) {
                $0.count = 2
            }
        )
    }

    let scheduler = DispatchQueue.testScheduler

    func testSync() {
        let store = TestStore(
            initialState: SyncState(count: 1, isSyncing: false),
            reducer: syncReducer,
            environment: SyncEnvironment(mainQueue: scheduler.eraseToAnyScheduler(),
                                         syncWithServer: { count in Effect(value: count + 3) })
        )

        store.assert(
            .send(SyncAction.sync) {
                $0.isSyncing = true
            },
            .do { self.scheduler.advance() },
            .receive(SyncAction.syncResponse(4)) {
                $0.isSyncing = false
                $0.count = 4
            }
        )
    }

//    func testMenu() {
//        let store = TestStore(
//            initialState: .init(count: 0, isSyncing: false),
//            reducer: menuReducer,
//            environment: MenuEnvironment()
//        )
//
//        store.assert(
//            .send(MenuAction.count(.countUp)) {
//                $0.count = 1
//                $0.syncState.count = 1
//            },
//            .send(MenuAction.sync(.sync)) {
//                $0.isSyncing = true
//                $0.syncState.isSyncing = true
//                XCTAssert($0.countState.isSyncing)
//            },
//            .do { self.scheduler.advance() },
//            .receive(MenuAction.sync(.syncResponse(4))) {
//                $0.isSyncing = false
//                $0.count = 4
//            }
//        )
//    }
}
