import Foundation

protocol LoginViewStateProtocol where Self: ObservableObject {
    var errorAlert: Bool { get set }
    var isFocusable: [Bool] { get set }
    var isSecureTextEntry: Bool { get set }
    var usernameValue: String { get set }
    var userPasswordValue: String { get set }
    func showErrorAlert()
    func hideErrorAlert()
}

final class LoginViewState: ObservableObject, AuthorizationModule.ViewState {
    
    @Published var activityIndicator = false
    @Published var errorAlert = false
    
    @Published var usernameValue: String = ""
    @Published var userPasswordValue: String = ""
    
    @Published var isFocusable: [Bool] = [true, false]
    @Published var isSecureTextEntry: Bool = false
    
    func startActivityIndicator() {
        self.activityIndicator = true
    }
    
    func stopActivityIndicator() {
        self.activityIndicator = false
    }
    
    func showErrorAlert() {
        self.errorAlert = true
    }
    
    func hideErrorAlert() {
        self.errorAlert = false
    }
    
    func isLoading() -> Bool {
        return activityIndicator
    }
}

extension LoginViewState: Equatable {
    static func == (lhs: LoginViewState, rhs: LoginViewState) -> Bool {
        return false
    }
}
