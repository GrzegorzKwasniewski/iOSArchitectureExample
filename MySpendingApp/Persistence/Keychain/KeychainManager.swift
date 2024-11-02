import KeychainAccess
import Combine
import Foundation

// MARK: - PROTOCOL DEFINITION

protocol KeychainProtocol {
    func storeSessionToken(token: String?) -> Future<Bool, AuthorizationError>
    func getSessionToken() -> Future<String, Never>
    func clearSessionToken() -> Future<Bool, AuthorizationError>
    func clearAll() -> Future<Bool, AuthorizationError>
}

// MARK: - CLASS DEFINITION

final class KeychainManager: PersistenceModule.Session {
    // MARK: - PRIVATE PROPERTIES

    private let keychain: Keychain
    private let accessTokenKey = "accessToken"

    // MARK: - INITIALIZER

    init(keychian: String = "com.kwasniewski.MySpendingApp") {
        keychain = Keychain(service: keychian)
    }

    // MARK: - INTERNAL METHODS

    func clearAllSync() {
        try? keychain.removeAll()
    }
}

// MARK: - COMBINE EXTENSION

extension KeychainManager {
    
    func storeSessionToken(token: String?) -> Future<Bool, AuthorizationError> {
        Future<Bool,AuthorizationError> { promise in
            // Clear seesion token.
            self.keychain[self.accessTokenKey] = nil
            
            // Assign new session token.
            self.keychain[self.accessTokenKey] = token
            
            // Check if new session token was assigned.
            guard self.keychain[self.accessTokenKey] != nil else {
                // Rise custom error.
                return promise(.failure(AuthorizationError.keychain(description: "token_not_saved")))
            }
            
            return promise(.success(true))
        }
    }
    
    func getSessionToken() -> Future<String, Never> {
        Future<String, Never> { promise in
            guard let token = self.keychain[self.accessTokenKey] else {
                // Send value event.
                return promise(.success(""))
            }
            return promise(.success(token))
        }
    }
    
    func clearSessionToken() -> Future<Bool, AuthorizationError> {
        Future<Bool, AuthorizationError> { promise in
            // Clear seesion token.
            self.keychain[self.accessTokenKey] = nil
            
            // Check if new session token was assigned.
            guard self.keychain[self.accessTokenKey] == nil else {
                // Rise custom error.
                return promise(.failure(.keychain(description: "token_not_cleared")))
            }
            
            // Send .completed event.
            promise(.success(true))
        }
    }
    
    func clearAll() -> Future<Bool, AuthorizationError> {
        Future<Bool, AuthorizationError> { promise in
            do {
                // Try to remove all keys.
                try self.keychain.removeAll()
                
            } catch {
                // Rise error.
                return promise(.failure(.keychain(description: "token_not_cleared")))
            }
            
            // Send .completed event.
            return promise(.success(true))
        }
    }
}

// MARK: - CUSTOM KEYCHAIN ERROR

struct KeychainError: Error {
    let message: String
}

extension KeychainError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }
}
