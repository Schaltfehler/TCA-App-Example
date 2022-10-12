import Foundation
import ComposableArchitecture
import SwiftUI


struct SyncClient {
    var fetch: (Int) async throws -> Int
}

extension SyncClient: DependencyKey {
    static let liveValue = Self(
        fetch: { currentCount in
            // There is no real server for syncing, so for demostration purpose lets simulate it.
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 5)
            return currentCount + Int.random(in: 1...5)
        }
    )
}

extension DependencyValues {
    var syncClient: SyncClient {
        get { self[SyncClient.self] }
        set { self[SyncClient.self] = newValue }
    }
}

struct Sync: ReducerProtocol {

    struct State: Equatable {
        var count: Int = 0
        var isSyncing: Bool = false

        var userSettingsState: UserSettings.State
    }

    enum Action: Equatable {
        case sync
        case syncResponse(Int)
        case userSettingsAction(UserSettings.Action)
    }

    @Dependency(\.syncClient)
    var syncClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .sync:
                state.isSyncing = true
                let currentCount = state.count
                return .task {
                    let syncedCount = try await syncClient.fetch(currentCount)
                    return .syncResponse(syncedCount)
                }

            case .syncResponse(let count):
                state.count = count
                state.isSyncing = false
                return .none

            case .userSettingsAction:
                return .none
            }
        }
        // Cannot convert value of type 'WritableKeyPath<Sync.State, String>' to expected argument type 'CasePath<Sync.State, UserSettings.State>'
        Scope(state: \State.userSettingsState, action: /Action.userSettingsAction) {
            UserSettings()
        }
    }
}

/// SyncView
/// Sync your counts with the Server

struct SyncView: View {

    let store: StoreOf<Sync>

    // For keeping the SyncState simple, i use a SwiftUI propery wrapper here to keep track of presenting UserSettings.
    // Of cause you can add this state to SyncState as well.
    @State
    var isUserSettingsPresented: Bool = false

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                ActivityIndicator(isAnimating: viewStore.isSyncing,
                                  style: .large)
                Text("Current Count: \(viewStore.count)")
                    .font(Font.largeTitle)
                
                Button("Sync with Server") {
                    viewStore.send(.sync)
                }
                .disabled(viewStore.isSyncing)
                .font(Font.largeTitle)
            }

            .navigationBarTitle("Sync Count")
            .navigationBarItems(trailing:
                                    Button("User Settings") {
                self.isUserSettingsPresented.toggle()
            }
                .sheet(isPresented: $isUserSettingsPresented) {
                    UserSettingsView(store:  self.store.scope(
                        // state: (Sync.State) -> UserSettings.State,
                        state: \.userSettingsState,
                        // action: (CountUp.Action) -> Menu.Action
                        action: Sync.Action.userSettingsAction
                    )
                    )
                }
            )
        }
    }
}

struct SyncView_Previews: PreviewProvider {
    static var previews: some View {
        SyncView(store: Store(
            initialState: Sync.State(userSettingsState: .init(name: "Someone")),
            reducer: Sync()
        ))
    }
}
