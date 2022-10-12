import Foundation
import ComposableArchitecture
import SwiftUI


struct CountUp: ReducerProtocol {
    struct State: Equatable {
        let isSyncing: Bool
        let userName: String

        var count: Int
    }

    enum Action: Equatable {
        case countUp
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .countUp:
            state.count += 1
            return .none
        }
    }
}

/// CountUpView
/// Count up on each button tap
/// Disable Button and show Loading Spinner when server sync is in progress

struct CountUpView: View {
    
    let store: StoreOf<CountUp>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    ActivityIndicator(isAnimating: viewStore.isSyncing,
                                      style: .large)
                    Text("User: \(viewStore.userName)")
                        .font(Font.largeTitle)
                    
                    Text("\(viewStore.count)")
                        .font(.system(size: 80))
                    
                    Button("+") {
                        viewStore.send(.countUp)
                    }
                    .frame(minWidth: 50, minHeight: 50)
                    .border(viewStore.isSyncing ? Color.gray : Color.blue, width: 2)
                    .font(Font.largeTitle)
                    .disabled(viewStore.isSyncing)
                }
                .navigationBarTitle("Count People")
            }
        }
    }
}

struct CountUpView_Previews: PreviewProvider {
    static var previews: some View {
        CountUpView(store: Store(initialState: CountUp.State(isSyncing: false, userName: "Freddy", count: 0),
                                 reducer: CountUp())
        )
    }
}
