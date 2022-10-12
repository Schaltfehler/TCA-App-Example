import SwiftUI
import ComposableArchitecture


struct Menu: ReducerProtocol {

    struct State: Equatable {
        var count: Int = 0
        var isSyncing: Bool = false
        var userName: String = "Freddy"

        var countUpState: CountUp.State {
            get {
                .init(isSyncing: self.isSyncing,
                             userName: self.userName,
                             count: self.count)
            }
            set {
                self.count = newValue.count
                self.isSyncing = newValue.isSyncing
            }
        }

        var syncState: Sync.State {
            get {
                .init(count: count,
                      isSyncing: isSyncing,
                      userSettingsState: .init(name: userName))
            }
            set {
                self.count = newValue.count
                self.isSyncing = newValue.isSyncing
                self.userName = newValue.userSettingsState.name
            }
        }
    }

    enum Action: Equatable {
        case countUpAction(CountUp.Action)
        case syncAction(Sync.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \State.countUpState, action: /Action.countUpAction) {
            CountUp()
        }

        Scope(state: \State.syncState, action: /Action.syncAction) {
            Sync()
        }
    }
}

struct MenuView: View {

    let store: StoreOf<Menu>

    var body: some View {
        NavigationView {
            List {
                NavigationLink("Count",
                               destination:
                                CountUpView(store:
                                                // Scope the Menu store into Store<CountUp.State, CountUp.Action>
                                            self.store.scope(
                                                // state: (Menu.State) -> CountUp.State,
                                                state: \Menu.State.countUpState,
                                                // action: (CountUp.Action) -> Menu.Action
                                                action: Menu.Action.countUpAction
                                            )
                                           )
                )

                NavigationLink("Sync",
                               destination:
                                // Scope the Menu store into Store<Sync.State, Sync.Action>
                                SyncView(store: self.store
                                    .scope(
                                        state: { (menuState: Menu.State) -> Sync.State in
                                            menuState.syncState
                                        },
                                        action: { (action: Sync.Action) -> Menu.Action in
                                            Menu.Action.syncAction(action)
                                        })
                                )
                )
            }
            .navigationBarTitle("Menu")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(store: Store(initialState: Menu.State(),
                              reducer: Menu()
                             ))
    }
}
