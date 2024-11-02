import RealmSwift
import Foundation

// MARK: - CLASS DEFINITION

final class UserModel: Object {
    
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var userName: String = ""
    @Persisted var email: String = ""
    
    convenience init(model: UserModel) {
        self.init()
        id = model.id
        email = model.email
        userName = model.userName
    }
    
    convenience init(response: AuthorizationResponseDto) {
        self.init()
        id = response.user.uuid
        email = response.user.email ?? ""
        userName = response.user.lastName ?? ""
    }
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}
