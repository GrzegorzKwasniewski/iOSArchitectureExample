import Combine
import OSLog
import SwiftUI

final class AppNavigation: BaseNavigation<AppNavigation.Navigation> {
    enum Navigation: NavigationResolving {
        case login
        case register
        case emailConfirmation(email: String)
        case forgotPassword
        case resetPassword(email: String)
        case changePassword
        case confirmLogout
        case deleteAccount
        case main

        @ViewBuilder
        func view() -> some View {
            switch self {
            case .login:
                ViewFactory.login
            case .main:
                ViewFactory.main
            }
        }
    }

    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        observePath()
    }

    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            Logger.navigation.error("Cannot open given url: \(urlString)")
            return
        }
        UIApplication.shared.open(url)
    }

    private func observePath() {
        $path
            .sink { path in
                Logger.navigation.info("NavigationPath changed: \(path)")
            }
            .store(in: &cancellables)
    }
}
