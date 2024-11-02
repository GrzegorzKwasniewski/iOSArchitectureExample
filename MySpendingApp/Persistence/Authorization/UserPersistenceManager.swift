import RealmSwift
import Combine

protocol UserPersistenceProtocol {
    func createUserModel(model: UserModel) -> Future<Bool, RealmError>
    func observeUserModel(model: UserModel) -> RealmPublishers.Value<Results<UserModel>>?
}

final class UserPersistenceManager: AuthorizationModule.Persistence {
    
    // MARK: - PRIVATE PROPERTIES

    private let realmBase: PersistenceModule.Base

    // MARK: - PUBLIC INITIALIZER

    init(realmType: RealmType) {
        realmBase = PersistenceStorage(realmType: realmType)
    }

    // MARK: - PUBLIC METHODS
    
    func createUserModel(model: UserModel) -> Future<Bool, RealmError> {
        return realmBase.create(model, update: false)
    }
    
    func observeUserModel(model: UserModel) -> RealmPublishers.Value<Results<UserModel>>? {
        return realmBase.realm.objects(UserModel.self).collectionPublisher
    }
}
