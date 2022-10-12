import XCTest
import ComposableArchitecture
import Combine
@testable import App_Example

@MainActor
class Demo2_Tests: XCTestCase {

    func testCountUp() {
        let store = TestStore(
            initialState: CountUp.State(isSyncing: false, userName: "Freddy", count: 0),
            reducer: CountUp()
        )

        store.send(.countUp) {
            $0.count = 1
        }
        store.send(.countUp) {
            $0.count = 2
        }
    }

    func testSync() async {
        let store = TestStore(
            initialState: Sync.State(count: 1, isSyncing: false,
                                     userSettingsState: .init()),
            reducer: Sync()
        )

        store.dependencies.syncClient = .init(fetch: { count in count + 3 })

        _ = await store.send(.sync) {
            $0.isSyncing = true
        }

        await store.receive(.syncResponse(4)) {
            $0.isSyncing = false
            $0.count = 4
        }
    }

    func testUserSettings() {
        let store = TestStore(
            initialState: UserSettings.State(name: "Freddy"),
            reducer: UserSettings()
        )

        store.send(.changeName("Freddi")) {
            $0.name = "Freddi"
        }
    }

    func testMenu() async {
        let store = TestStore(
            initialState: .init(count: 0, isSyncing: false),
            reducer: Menu()
        )

        store.dependencies.syncClient = .init(fetch: { count in count + 3 })

        _ = await store.send(.countUpAction(.countUp)) {
            $0.count = 1
            $0.syncState.count = 1
        }

        _ = await store.send(.syncAction(.sync)) {
            $0.isSyncing = true
            $0.syncState.isSyncing = true
            XCTAssert($0.countUpState.isSyncing)
        }

        await store.receive(.syncAction(.syncResponse(4))) {
            $0.isSyncing = false
            $0.count = 4
        }
    }
}
