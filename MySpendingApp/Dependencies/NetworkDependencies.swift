import Factory

extension Container {
    
    var authorizationNetworkManager: Factory<AuthorizationModule.Network> {
        self { AuthorizationNetworkManager() }
    }
}
