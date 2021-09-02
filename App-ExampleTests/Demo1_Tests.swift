import XCTest
import ComposableArchitecture
@testable import App_Example

class Demo1_Tests: XCTestCase {

    func testSimpleCounter() {

        let store = TestStore(
            initialState: CounterState(count: 0),
            reducer: counterReducer,
            environment: CounterEnvironment()
        )

        store.assert(
            TestStore.Step.send(CounterAction.increment) { (state: inout CounterState) in
                // set expectation
                state.count = 1
            },
            .send(.increment) {
                $0.count = 2
            },
            .send(.decrement) {
                $0.count = 1
            }
        )
    }
}
