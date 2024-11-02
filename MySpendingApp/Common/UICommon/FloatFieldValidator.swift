import Foundation

open class FloatFieldValidator: Equatable {
    public var message: LocalizedStringResource = ""

    public var text: String = ""

    public init(message: LocalizedStringResource) {
        self.message = message
    }

    func validate() -> Bool {
        false
    }

    public static func == (lhs: FloatFieldValidator, rhs: FloatFieldValidator) -> Bool {
        lhs === rhs && lhs.text == rhs.text && lhs.message.key == rhs.message.key
    }
}

public class EmptyFieldValidator: FloatFieldValidator {
    override func validate() -> Bool {
        !text.isEmpty
    }
}

public class NameValidator: FloatFieldValidator {
    private let regex = /^[A-Za-z\\-\\s]+$/

    override func validate() -> Bool {
        text.contains(regex)
    }
}

public class EmailValidator: FloatFieldValidator {
    private let regex = /^\w+([\.+-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

    override func validate() -> Bool {
        text.contains(regex)
    }
}

public class ZipCodeValidator: FloatFieldValidator {
    private let regex = /^\d{5}(-\d{4})?$/

    override func validate() -> Bool {
        text.contains(regex)
    }
}

public class PasswordValidator: FloatFieldValidator {
    private let regex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+.])[A-Za-z\d!@#$%^&*()_+.]{8,16}$/

    override func validate() -> Bool {
        text.contains(regex)
    }
}

public class ConfirmPasswordValidator: FloatFieldValidator {
    let textToMatch: String

    public init(textToMatch: String, message: LocalizedStringResource) {
        self.textToMatch = textToMatch
        super.init(message: message)
    }

    override func validate() -> Bool {
        text == textToMatch
    }
}
