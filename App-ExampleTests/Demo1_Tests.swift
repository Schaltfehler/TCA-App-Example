import XCTest
import ComposableArchitecture
@testable import App_Example

class Demo1_Tests: XCTestCase {
    
    func testSimpleCounter() {
        
        let store = TestStore(
            initialState: Counter.State(count: 0),
            reducer: Counter()
        )
        
        store.send(Counter.Action.increment) { (state: inout Counter.State) in
            // set expectation
            state.count = 1
        }
        
        store.send(.increment) { state in
            state.count = 2
        }
        
        store.send(.decrement) {
            $0.count = 1
        }
    }
}
