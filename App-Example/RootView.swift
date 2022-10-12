import SwiftUI
import ComposableArchitecture

struct RootView: View {

    var body: some View {
        TabView {
            CounterView(
                store: Store(
                    initialState: Counter.State(),
                    reducer: Counter()
                    // Demo: Use debug on this reducer to see each action and each state change
                    //._printChanges()
                )
            )
            .tabItem {
                Image(systemName: "1.square")
                Text("Demo 1")
            }

            MenuView(
                store: Store(
                    initialState: Menu.State(),
                    reducer: Menu()
//                        .signpost()
                        ._printChanges()
                )
            )
            .tabItem {
                Image(systemName: "2.square")
                Text("Demo 2")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        return RootView()
    }
}
