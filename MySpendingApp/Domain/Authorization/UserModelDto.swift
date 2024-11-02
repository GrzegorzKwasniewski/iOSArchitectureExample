
struct UserModelDto {
    
    // MARK: - PUBLIC PROPERTIES

    var id: String
    var userName: String
    var email: String

    // MARK: - PUBLIC INITIALIZER

    init(id: String, userName: String, email: String) {
        self.id = id
        self.userName = userName
        self.email = email
    }

    init() {
        id = ""
        userName = ""
        email = ""
    }
}

// MARK: - EQUATABLE

extension UserModelDto: Equatable {
    public static func == (lhs: UserModelDto, rhs: UserModelDto) -> Bool {
        return lhs.id == rhs.id
    }
}
