import Factory

extension Container {
    
    var authorizationDomainManager: Factory<AuthorizationModule.Domain> {
        self { AuthorizationDomainManager(
            authorizationManager: self.authorizationNetworkManager(),
            userStorageManager: self.userPersistenceManager(),
            keychainManager: self.keychainManager()) }
    }
}
