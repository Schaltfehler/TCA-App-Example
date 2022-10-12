import SwiftUI
import ComposableArchitecture


struct Counter: ReducerProtocol {
    struct State: Equatable {
        var count = 0
    }

    enum Action: Equatable {
        case increment // count up
        case decrement // count down
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .increment:
            state.count += 1
            return .none

        case .decrement:
            state.count -= 1
            return .none
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Counter>

    var body: some View {
        // Transform a store into an observable view store
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    Text("\(viewStore.count)")
                        .font(.system(size: 80))
                    
                    HStack {
                        Button("−") {
                            viewStore.send(.decrement)
                        }
                        .frame(minWidth: 50, minHeight: 50)
                        .border(Color.blue, width: 2)

                        Button("+") {
                            viewStore.send(.increment)
                        }
                        .frame(minWidth: 50, minHeight: 50)
                        .border(Color.blue, width: 2)
                    }
                    .font(Font.largeTitle)
                }
                .navigationBarTitle("Simple Count")
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: Store(
                initialState: Counter.State(),
                reducer: Counter()
            )
        )
    }
}
