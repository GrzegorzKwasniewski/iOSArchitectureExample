
enum AuthorizationError: Error {
    case parsing(description: String)
    case network(description: String)
    case keychain(description: String)
}
