import Factory

extension Container {
    
    var userPersistenceManager: Factory<AuthorizationModule.Persistence> {
        self { UserPersistenceManager() }
    }
    
    var keychainManager: Factory<PersistenceModule.Session> {
        self { KeychainManager() }
    }
}
