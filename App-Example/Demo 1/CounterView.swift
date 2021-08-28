import SwiftUI
import ComposableArchitecture


struct CounterState: Equatable {
    var count = 0
}

enum CounterAction: Equatable {
    case increment
    case decrement
}

struct CounterEnvironment {}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, _ in
    switch action {
    case .increment:
        state.count += 1
        return Effect.none
        
    case .decrement:
        state.count -= 1
        return Effect.none
    }
}


struct CounterView: View {
    let store: Store<CounterState, CounterAction>

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
                initialState: CounterState(),
                reducer: counterReducer,
                environment: CounterEnvironment()
            )
        )
    }
}
