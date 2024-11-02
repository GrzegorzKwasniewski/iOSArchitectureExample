import Factory

extension Container {
    
    var loginView: Factory<LoginView> {
        self { LoginView() }
    }
    
    var loginViewModel: Factory<LoginViewModel<LoginViewState>> {
        self { LoginViewModel(
            navigation: self.appNavigation(),
            authDomainManager: self.authorizationDomainManager(),
            viewState: self.loginViewState())
        }
    }
    
    var loginViewState: Factory<LoginViewState> {
        self { LoginViewState() }
    }
}
