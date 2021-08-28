import SwiftUI
import ComposableArchitecture

struct MenuState: Equatable {

    var count: Int = 0
    var isSyncing: Bool = false
    var userName: String = "Freddy"

    var countState: CountUpState {
        get {
            CountUpState(isSyncing: self.isSyncing,
                         userName: self.userName,
                         count: self.count)
        }
        set {
            self.count = newValue.count
            self.isSyncing = newValue.isSyncing
        }
    }

    var syncState: SyncFeatureState {
        get {
            SyncFeatureState(userName: userName,
                             count: self.count,
                             isSyncing: self.isSyncing)
        }
        set {
            self.userName = newValue.userName
            self.count = newValue.count
            self.isSyncing = newValue.isSyncing
        }
    }
}

enum MenuAction: Equatable {
    case count(CountUpAction)
    case featureSync(SyncFeatureAction)
}

struct MenuEnvironment {
    let countUpEnvironment: CountUpEnvironment
    let syncEnvironment: SyncFeatureEnvironment

    static let mock = MenuEnvironment(countUpEnvironment: CountUpEnvironment(),
                                      syncEnvironment: SyncFeatureEnvironment.mock)
}

let menuReducer = Reducer<MenuState, MenuAction, MenuEnvironment>
    .combine(
        countUpReducer.pullback(
            state: \MenuState.countState,
            action: /MenuAction.count,
            environment: { $0.countUpEnvironment }
        ),
        syncFeatureReducer.pullback(
            state: \MenuState.syncState,
            action: /MenuAction.featureSync,
            environment: { $0.syncEnvironment }
        )
)


struct MenuView: View {

    let store: Store<MenuState, MenuAction>

    var body: some View {

        NavigationView {
            List {
                NavigationLink("Count",
                               destination:
                    CountUpView(store:
                        // scope into MenuState.countState
                        self.store.scope(state: { $0.countState },
                                         action: MenuAction.count)
                    )
                )
                NavigationLink("Sync",
                               destination:
                    SyncView(store:self.store.scope(
                        state: { (menuState: MenuState) -> SyncFeatureState in
                            menuState.syncState
                    },
                        action: { (localAction: SyncFeatureAction) in
                            MenuAction.featureSync(localAction)
                    }
                    ))
                )
            }
            .navigationBarTitle("People Count App")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(store: Store(initialState: MenuState(),
                              reducer: menuReducer,
                              environment: MenuEnvironment.mock))
    }
}
