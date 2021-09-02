import Foundation
import ComposableArchitecture

let syncFeatureReducer = Reducer<SyncFeatureState, SyncFeatureAction, SyncFeatureEnvironment>
    .combine(
        syncReducer.pullback(
            state: \SyncFeatureState.syncState,
            action: /SyncFeatureAction.sync,
            environment: { $0.syncEnvironment }
        ),
        userSettingsReducer.pullback(
            state: \SyncFeatureState.userState,
            action: /SyncFeatureAction.userSettings,
            environment: { $0.userSettingsEnvironment }
        )
)

struct SyncFeatureState: Equatable {
    var count: Int
    var isSyncing: Bool
    
    var userName: String
    
    init(
        userName: String,
        count: Int = 0,
        isSyncing: Bool = false
    ) {
        self.userName = userName
        self.count = count
        self.isSyncing = isSyncing
    }
    
    var syncState: SyncState {
        get { SyncState(count: count, isSyncing: isSyncing) }
        set {
            self.isSyncing = newValue.isSyncing
            self.count = newValue.count
        }
    }
    
    var userState: UserSettingsState {
        get { UserSettingsState(name: userName) }
        set { self.userName = newValue.name }
    }
}

enum SyncFeatureAction: Equatable {
    case sync(SyncAction)
    case userSettings(UserSettingsAction)
}

struct SyncFeatureEnvironment {
    let syncEnvironment: SyncEnvironment
    let userSettingsEnvironment: UserSettingsEnvironment
}

extension SyncFeatureEnvironment {
    static let mock = SyncFeatureEnvironment(syncEnvironment: SyncEnvironment.mock,
                                             userSettingsEnvironment: UserSettingsEnvironment())
}
