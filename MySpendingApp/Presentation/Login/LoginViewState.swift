import Foundation

protocol LoginViewStateProtocol where Self: ObservableObject {
    var email: String { get set }
    var emailError: LocalizedStringResource? { get set }
    var password: String { get set }
    var passwordError: LocalizedStringResource? { get set }
}

final class LoginViewState: ObservableObject, AuthorizationModule.ViewState {
        
    @Published var email: String = ""
    @Published var emailError: LocalizedStringResource? = nil
    
    @Published var password: String = ""
    @Published var passwordError: LocalizedStringResource? = nil
    
}

extension LoginViewState: Equatable {
    static func == (lhs: LoginViewState, rhs: LoginViewState) -> Bool {
        return false
    }
}
