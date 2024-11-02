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
            .ignoreOutput()
            .sink(
                receiveCompletion: { [weak self] value in
                                        
                    guard let self = self else { return }
                    switch value {
                    case let .failure(error):
                        self.loginViewState.showErrorAlert()
                        Logger.navigation.error("Email login error. Error = \(String(describing: error.getLastError()))")
                    case .finished:
                        self.goToHome()
                    }
                },
                receiveValue: { _ in
                    // No value will be received, so we are ignoring this block.
                })
            .store(in: &disposables)
    }
    
    func goToHome() {
        navigation.popTo(.main)
    }
    
    func pushPasswordReminderView() {
        Logger.navigation.info("Push password reminder view")
    }
}
