import Foundation
import ComposableArchitecture
import SwiftUI

struct CountUpState: Equatable {
    let isSyncing: Bool
    let userName: String
    
    var count: Int
}

enum CountUpAction: Equatable {
    case countUp
}

struct CountUpEnvironment {}

let countUpReducer = Reducer<CountUpState, CountUpAction, CountUpEnvironment> { state, action, _ in
    switch action {
    case .countUp:
        state.count += 1
        return .none
    }
}
// Demo: Use debug on this reducer to see each action and each state change
//.debug()


/// CountUpView
/// Count up on each button tap
/// Disable Button and show Loading Spinner when server sync is in progress

struct CountUpView: View {
    
    let store: Store<CountUpState, CountUpAction>
    
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
                .navigationBarTitle("Count Peolpe")
            }
        }
    }
}


#if DEBUG

struct CountUpView_Previews: PreviewProvider {
    static var previews: some View {
        CountUpView(store: Store(initialState: CountUpState(isSyncing: false, userName: "Freddy", count: 0),
                                 reducer: countUpReducer,
                                 environment: CountUpEnvironment())
        )
    }
}

#endif
