import Foundation

struct UserDto: Codable {
    let uuid: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let isActive: Bool
    let isSocialLogin: Bool

    var fullName: String? {
        if let firstName, let lastName {
            return "\(firstName) \(lastName)"
        }
        return nil
    }
}
