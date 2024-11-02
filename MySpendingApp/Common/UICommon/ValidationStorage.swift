import SwiftUI

final class ValidationStorage {
    private(set) var validators = [FloatFieldValidator]()

    func addValidators(_ validators: [FloatFieldValidator]) {
        self.validators = validators
    }

    func validate() -> (Bool, LocalizedStringResource?) {
        var isValid = true
        var message: LocalizedStringResource?
        for validator in validators {
            if !validator.validate() {
                isValid = false
                message = validator.message
                break
            }
        }
        return (isValid, message)
    }
}
