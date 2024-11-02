import Moya
import CombineMoya
import Combine

protocol AuthorizationNetworkProtocol {
    func postLogin(email: String, password: String) -> AnyPublisher<AuthorizationResponseDto, MoyaError>
    func postLogout() -> AnyPublisher<Response, MoyaError>
}

final class AuthorizationNetworkManager: AuthorizationModule.Network {

    private let server: Server
    private let provider = MoyaProvider<AuthorizationApi>(plugins: [NetworkLoggerPlugin()])

    // MARK: - INITIALIZER

    init(server: Server = .production) {
        self.server = server
    }

    // MARK: - INTERNAL METHODS

    func postLogin(email: String, password: String) -> AnyPublisher<AuthorizationResponseDto, MoyaError> {
        provider
            .requestPublisher(.userLogin(userName: email, userPassword: password, server: server))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(AuthorizationResponseDto.self)
    }

    func postLogout() -> AnyPublisher<Response, MoyaError> {
        provider
            .requestPublisher(.logout(server: server))
            .filterSuccessfulStatusAndRedirectCodes()
    }
}
