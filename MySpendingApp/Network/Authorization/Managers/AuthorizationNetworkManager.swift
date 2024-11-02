import Moya
import CombineMoya
import Combine

protocol AuthorizationNetworkProtocol {
    func postLogin(email: String, password: String) -> AnyPublisher<Response, MoyaError>
    func postLogout() -> AnyPublisher<Empty, MoyaError>
}

final class AuthorizationNetworkManager: AuthorizationModule.Network {

    private let server: Server
    private let authApiProvider = MoyaProvider<AuthorizationApi>(plugins: MoyaPlugin.default)

    // MARK: - INITIALIZER

    init(server: Server = .production) {
        self.server = server
    }

    // MARK: - INTERNAL METHODS

    func postLogin(email: String, password: String) -> AnyPublisher<AuthorizationResponseDto, MoyaError> {
        authApiProvider
            .provider.requestPublisher(.userLogin(userName: email, userPassword: password, server: server))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(AuthorizationResponseDto.self)
    }

    func postLogout() -> AnyPublisher<Response, MoyaError> {
        authApiProvider
            .provider.requestPublisher(.logout(server: server))
            .filterSuccessfulStatusAndRedirectCodes()
    }
}
