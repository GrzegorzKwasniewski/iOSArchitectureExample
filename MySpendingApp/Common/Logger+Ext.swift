import Foundation
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""

    // MARK: - ViewModels

    static let authorization = Logger(subsystem: subsystem, category: "AuthorizationViewModel")

    // MARK: - NAVIGATION LOGGER

    static let navigation = Logger(subsystem: subsystem, category: "App.Navigation")
}
