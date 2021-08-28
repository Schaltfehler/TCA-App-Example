import XCTest
import ComposableArchitecture
import Combine
@testable import App_Example

class Demo2_Tests: XCTestCase {

    func testCountUp() {
        let store = TestStore(
            initialState: CountUpState(isSyncing: false, userName: "Freddy", count: 0),
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

    let scheduler = DispatchQueue.test

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

    func testUserSettings() {
        let store = TestStore(
            initialState: UserSettingsState(name: "Freddy"),
            reducer: userSettingsReducer,
            environment: UserSettingsEnvironment()
        )

        store.assert(
            .send(.changeName("Freddi")) {
                $0.name = "Freddi"
            }
        )
    }

    func testMenu() {

        let environment = SyncFeatureEnvironment(syncEnvironment:
            SyncEnvironment(mainQueue: scheduler.eraseToAnyScheduler(),
                            syncWithServer: { count in Effect(value: count + 3) }
            ),
                                                 userSettingsEnvironment: UserSettingsEnvironment()
        )

        let store = TestStore(
            initialState: .init(count: 0, isSyncing: false),
            reducer: menuReducer,
            environment: MenuEnvironment(countUpEnvironment: CountUpEnvironment(),
                                         syncEnvironment:environment )
        )

        store.assert(
            .send(MenuAction.count(.countUp)) {
                $0.count = 1
                $0.syncState.count = 1
            },
            .send(MenuAction.featureSync(SyncFeatureAction.sync(SyncAction.sync)) ) {
                $0.isSyncing = true
                $0.syncState.isSyncing = true
                XCTAssert($0.countState.isSyncing)
            },
            .do { self.scheduler.advance() },
            .receive(MenuAction.featureSync(.sync(.syncResponse(4)))) {
                $0.isSyncing = false
                $0.count = 4
            }
        )
    }
}
