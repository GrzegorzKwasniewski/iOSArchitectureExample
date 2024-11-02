import AuthenticationServices
import Factory
import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel<LoginViewState> = Container.shared.loginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            HeaderView(title: "Zaloguj się")

            FloatingForm { isValid in
                formFields

                PrimaryButton(title: "Zaloguj się", action: {
                    if isValid() {
                        viewModel.loginUser()
                    }
                })
            }

            SplitDividerView()

        }
        .frame(maxHeight: .infinity)
        .padding()
        .background(.whiteBG)
        .backBarButton()
    }

    private var formFields: some View {
        VStack {
            FloatingTextField(
                placeholder: "E-mail",
                text: $viewModel.viewState.email,
                errorMessage: $viewModel.viewState.emailError)
                .addValidator(EmptyFieldValidator(message: "Podaj e-mail"), EmailValidator(message: "E-mail jest nieprawidłowy"))
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

            FloatingTextField(isSecure: true, placeholder: "Hasło", text: $viewModel.viewState.password, errorMessage: $viewModel.viewState.passwordError)

            UnderlinedButton(title: "Przypomnij hasło", alignment: .topTrailing, action: {
                viewModel.pushPasswordReminderView()
            })
        }
    }
}

extension ViewFactory {
    static var login: LoginView {
        Container.shared.loginView()
    }
}

#Preview {
    ViewFactory.login
}
