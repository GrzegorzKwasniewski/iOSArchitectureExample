
enum AuthorizationModule {
    typealias Network = AuthorizationNetworkProtocol
    typealias Persistence = UserPersistenceProtocol
    typealias Domain = AuthorizationDomainProtocol
    typealias Session = KeychainProtocol
}
