import Foundation

struct AuthorizationResponseDto: Codable {
    let accessTokenExpiresIn: Int
    let refreshTokenExpiresIn: Int
    let accessToken: String
    let user: UserDto
}
