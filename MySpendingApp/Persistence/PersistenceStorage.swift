import Realm
import RealmSwift
import Combine

// MARK: - PROTOCOL DEFINITION

public protocol BaseStorageProtocol: AnyObject {
    
    var realm: Realm {get}
    
    func create<T: Object>(_ data: T, update: Bool) -> Future<Bool, RealmError>
    func deleteByType<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Future<Bool, RealmError>
}

// MARK: - EXTENSION DEFINITION

public enum RealmType {
    case production
    case test
}

final class PersistenceStorage: PersistenceModule.Base {
    
    let realm: Realm
    
    public init(realmType: RealmType) {
        switch realmType {
        case .production:
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            let realm = try! Realm(configuration: config)
            self.realm = realm
        case .test:
            let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
            let realm = try! Realm(configuration: configuration)
            self.realm = realm
        }
    }
}

// MARK: - CREATE

public enum RealmError: Error {
    case generic(description: String)
}

extension PersistenceStorage {
    
    public func create<T: Object>(_ data: T, update: Bool) -> Future<Bool, RealmError> {
        return Future<Bool, RealmError> { [weak self] promise in
            
            do {
                try self?.realm.write { [weak self] in
                    switch (update) {
                    case true:
                        self?.realm.add(data, update: Realm.UpdatePolicy.modified)
                    case false:
                        self?.realm.add(data)
                    }
                }
            } catch {
                return promise(.failure(RealmError.generic(description: error.localizedDescription)))
            }
            
            return promise(.success(true))

        }
    }
}

// MARK: - READ

extension PersistenceStorage {
    
    func read<T: Object>(_ type: T.Type, key: Any) -> Future<T, RealmError> {
        return Future<T, RealmError> { [weak self] promise in

            guard let realm = self?.realm else {
                return promise(.failure(RealmError.generic(description: "database_not_initialized")))
            }

            let model = realm.object(ofType: type, forPrimaryKey: key)

            switch model == nil {
            case true:
                return promise(.failure(RealmError.generic(description: "model_not_found")))
            case false:
                return promise(.success(model!))
            }
        }
    }
}

// MARK: - UPDATE

extension PersistenceStorage {
    
    func update(action: @escaping () -> Void) -> Future<Bool, RealmError> {
        return Future<Bool, RealmError> { [weak self] promise in

            guard let realm = self?.realm else {
                return promise(.failure(RealmError.generic(description: "data_base_not_initialized")))
            }

            do {
                try realm.write {
                    action()
                }
            } catch {
                return promise(.failure(RealmError.generic(description: error.localizedDescription)))
            }

            return promise(.success(true))
        }
    }
}

// MARK: - DELETE

extension PersistenceStorage {
    
    func delete<T: Object>(_ data: T) -> Future<Bool, RealmError> {
        return Future<Bool, RealmError> { [weak self] promise in

            guard let realm = self?.realm else {
                return promise(.failure(RealmError.generic(description: "data_base_not_initialized")))
            }

            do {
                try realm.write {
                    realm.delete(data)
                }
            } catch {
                return promise(.failure(RealmError.generic(description: error.localizedDescription)))
            }

            return promise(.success(true))

        }
    }

    func deleteByType<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Future<Bool, RealmError> {
        return Future<Bool, RealmError> { [weak self] promise in
            
            guard let realm = self?.realm else {
                return promise(.failure(RealmError.generic(description: "data_base_not_initialized")))
            }

            let objects = predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)

            do {
                try realm.write {
                    realm.delete(objects)
                }
            } catch {
                return promise(.failure(RealmError.generic(description: error.localizedDescription)))
            }

            return promise(.success(true))
        }
    }

    func deleteAll() -> Future<Bool, RealmError> {
        return Future<Bool, RealmError> { [weak self] promise in

            guard let realm = self?.realm else {
                return promise(.failure(RealmError.generic(description: "data_base_not_initialized")))
            }

            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                return promise(.failure(RealmError.generic(description: error.localizedDescription)))
            }

            return promise(.success(true))

        }
    }
}
