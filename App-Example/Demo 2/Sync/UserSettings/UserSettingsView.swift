import Foundation
import ComposableArchitecture
import SwiftUI

struct UserSettings: ReducerProtocol {

    struct State: Equatable {
        var name = ""
    }

    enum Action: Equatable {
        case changeName(String)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case let .changeName(name):
            state.name = name
            return .none
        }
    }
}

/// UserSettingsView
/// Update your Username

struct UserSettingsView: View {
    
    let store: StoreOf<UserSettings>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading) {
                    Text("Current user:")
                        .font(Font.largeTitle)
                    
                    TextField(
                        "User Name",
                        text: viewStore.binding(
                            get: {
                                $0.name
                            },
                            send: {
                                .changeName($0)
                            }
                        )
                    )
                    .font(Font.largeTitle)
                    
                    Spacer()
                }
                .padding(.init(top: 0, leading: 20, bottom: 100, trailing: 20))
                .navigationBarTitle("User Settings")
            }
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(store: Store(
            initialState: UserSettings.State(name: "Freddy"),
            reducer: UserSettings())
        )
    }
}
