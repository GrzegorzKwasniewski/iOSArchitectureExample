import Foundation
import Combine
import Moya


protocol AuthorizationDomainProtocol {
    func emailLoginMergeWithToken(userEmail: String, userPassword: String) -> AnyPublisher<Bool, AggregatedError>
    func emailLoginMergeWithPersitence(userEmail: String, userPassword: String) -> AnyPublisher<Bool, AggregatedError>
}

final class AuthorizationDomainManager: AuthorizationModule.Domain {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let authorizationManager: AuthorizationModule.Network
    private let userStorageManager: AuthorizationModule.Persistence
    private let keychainManager: AuthorizationModule.Session
    
    // MARK: - INITIALIZER
    
    init(
        authorizationManager: AuthorizationModule.Network,
        userStorageManager: AuthorizationModule.Persistence,
        keychainManager: AuthorizationModule.Session
    ) {
        self.authorizationManager = authorizationManager
        self.userStorageManager = userStorageManager
        self.keychainManager = keychainManager
    }
    
    // MARK: - INTERNAL METHODS
    
    func emailLoginMergeWithToken(userEmail: String, userPassword: String) -> AnyPublisher<Bool, AggregatedError> {
        authorizationManager
            .postLogin(email: userEmail, password: userPassword)
            .mapError { (moyaError) -> AggregatedError in
                AggregatedError().appendError(error: moyaError)
            }
            .flatMap { (response) in
                return self.keychainManager.storeSessionToken(token: response.accessToken)
                    .mapError { (authorizationError) -> AggregatedError in
                        AggregatedError().appendError(error: authorizationError)
                    }
            }
            .eraseToAnyPublisher()
    }
    
    func emailLoginMergeWithPersitence(userEmail: String, userPassword: String) -> AnyPublisher<Bool, AggregatedError> {
        authorizationManager
            .postLogin(email: userEmail, password: userPassword)
            .mapError { (moyaError) -> AggregatedError in
                AggregatedError().appendError(error: moyaError)
            }.flatMap { (response) in
                return self.userStorageManager
                    .createUser(model: UserModel(response: response))
                    .mapError { (authorizationError) -> AggregatedError in
                        AggregatedError().appendError(error: authorizationError)
                    }
            }
            .eraseToAnyPublisher()
    }
}
