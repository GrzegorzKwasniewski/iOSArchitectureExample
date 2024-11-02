import Factory

extension Container {
    
    var userPersistenceManager: Factory<AuthorizationModule.Persistence> {
        self { UserPersistenceManager() }
    }
}
