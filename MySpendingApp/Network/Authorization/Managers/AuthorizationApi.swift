import Foundation
import KeychainAccess
import Moya

enum AuthorizationApi {
    case userRegister(userData: AuthorizationData, server: Server)
    case userLogin(userName: String, userPassword: String, server: Server)
    case logout(server: Server)
}

extension AuthorizationApi: TargetType {
    var baseURL: URL {
        switch self {
        case let .userRegister(_, server),
            let .userLogin(_, _, server),
            let .logout(server):
            return server.baseUrl
        }
    }

    var path: String {
        switch self {
        case .userLogin:
            return "/login"
        case .userRegister:
            return "/accounts/register"
        case .logout:
            return "/accounts/register"
        }
    }

    var method: Moya.Method {
        switch self {
        case .userLogin,
             .userRegister,
             .logout:
            return .post
        default:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .userLogin(userName, userPassword, _):
            let parameters = ["username": userName, "password": userPassword] as [String: Any]
            return requestWithBodyParameters(parameters)
        case let .userRegister(userData, _):
            var parameters = ["email": userData.email,
                              "username": userData.username,
                              "password": userData.password] as [String: Any]
            if let firstName = userData.firstName {
                parameters["first_name"] = firstName
            }
            if let lastName = userData.lastName {
                parameters["last_name"] = lastName
            }
            return requestWithBodyParameters(parameters)
        default:
            return .requestPlain
        }
    }

    private func requestWithParameters(_ parameters: [String: Any]) -> Task {
        let encoding = URLEncoding(arrayEncoding: .noBrackets)
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    private func requestWithBodyParameters(_ parameters: [String: Any]) -> Task {
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }

    var keychain: Keychain {
        return Keychain(service: "com.kwasniewski.MySpendingApp")
    }

    var accessTokenKey: String {
        return "accessToken"
    }

    var headers: [String: String]? {
        switch self {
        default:
            return createHeaders()
        }
    }

    func createHeaders() -> [String: String]? {
        if let token = keychain[accessTokenKey] {
            return ["Content-type": "application/json", "Authorization": "\(token)"]
        } else {
            return ["Content-type": "application/json"]
        }
    }
}
