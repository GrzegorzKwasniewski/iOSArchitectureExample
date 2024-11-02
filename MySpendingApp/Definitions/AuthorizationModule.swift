
enum AuthorizationModule {
    typealias Network = AuthorizationNetworkProtocol
    typealias Persistence = UserPersistenceProtocol
    typealias Domain = AuthorizationDomainProtocol
    typealias ViewModel = LoginViewModelProtocol
    typealias ViewState = LoginViewStateProtocol
}
