import Combine
import Foundation
import OSLog

protocol LoginViewModelProtocol<ViewState> where Self: ObservableObject {
    
    associatedtype ViewState
    
    var loginViewState: ViewState { get set }
    func loginUser()
    func pushPasswordReminderView()
}

final class LoginViewModel<ViewState>: AuthorizationModule.ViewModel where ViewState: AuthorizationModule.ViewState {
        
    // MARK: - PRIVATE PROPERTIES
    
    private let authDomainManager: AuthorizationModule.Domain
    private let navigation: AppNavigation
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - OBSERVED PROPERTIES
    
    @Published var loginViewState: ViewState
    
    // MARK: - INITIALIZER
    
    init(navigation: AppNavigation, authDomainManager: AuthorizationModule.Domain, viewState: ViewState) {
        self.navigation = navigation
        self.authDomainManager = authDomainManager
        self.loginViewState = viewState
    }
    
    // MARK: - PUBLIC METHODS
    
    func loginUser() {
        authDomainManager
            .emailLoginMergeWithToken(
                userEmail: loginViewState.usernameValue,
                userPassword: loginViewState.userPasswordValue
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if let self, case let .failure(error) = completion {
                        self.loginViewState.showErrorAlert()
                        Logger.navigation.error("Email login error. Error = \(String(describing: error.getLastError()))")
                    }
                },
                receiveValue: { _ in
                    self.goToHome()
                })
            .store(in: &disposables)
    }
    
    func goToHome() {
        navigation.push(.main)
    }
    
    func pushPasswordReminderView() {
        Logger.navigation.info("Push password reminder view")
    }
}
