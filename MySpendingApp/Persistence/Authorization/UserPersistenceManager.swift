import RealmSwift
import Combine

protocol UserPersistenceProtocol {
    func createUser(model: UserModel) -> Future<Bool, RealmError>
    func observeUser(model: UserModel) -> RealmPublishers.Value<Results<UserModel>>?
}

final class UserPersistenceManager: AuthorizationModule.Persistence {
    
    // MARK: - PRIVATE PROPERTIES

    private let realmBase: PersistenceModule.Base

    // MARK: - PUBLIC INITIALIZER

    init(realmType: RealmType = .production) {
        realmBase = PersistenceStorage(realmType: realmType)
    }

    // MARK: - PUBLIC METHODS
    
    func createUser(model: UserModel) -> Future<Bool, RealmError> {
        return realmBase.create(model, update: false)
    }
    
    func observeUser(model: UserModel) -> RealmPublishers.Value<Results<UserModel>>? {
        return realmBase.realm.objects(UserModel.self).collectionPublisher
    }
}
