import SwiftUI

public struct FloatingFieldStyle {
    public struct ColorState {
        var idle: Color
        var focused: Color
        var error: Color
        var disabled: Color

        public init(idle: Color, focused: Color, error: Color, disabled: Color) {
            self.idle = idle
            self.focused = focused
            self.error = error
            self.disabled = disabled
        }
    }

    var backgroundColor: ColorState
    var textColor: ColorState
    var placeholderColor: ColorState
    var borderColor: ColorState
    var descriptionColor: ColorState

    var textFont: Font
    var placeholderFont: Font
    var descriptionFont: Font


    public init(backgroundColor: ColorState, textColor: ColorState, placeholderColor: ColorState, borderColor: ColorState, descriptionColor: ColorState,
                textFont: Font,
                placeholderFont: Font,
                descriptionFont: Font) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.borderColor = borderColor
        self.descriptionColor = descriptionColor
        self.textFont  = textFont
        self.placeholderFont  = placeholderFont
        self.descriptionFont  = descriptionFont
    }
}

// MARK: - ENVIRONMENT VALUE

public extension EnvironmentValues {
    var floatingFieldStyle: FloatingFieldStyle {
        get {
            self[FloatFieldStyleKey.self]
        }
        set {
            self[FloatFieldStyleKey.self] = newValue
        }
    }
}

// MARK: - ENVIRONMENT KEY

struct FloatFieldStyleKey: EnvironmentKey {

    static var defaultValue = FloatingFieldStyle(
        backgroundColor: .init(idle: .white, focused: .white, error: .red, disabled: .gray),
        textColor: .init(idle: .black, focused: .blue, error: .red, disabled: .gray),
        placeholderColor: .init(idle: .gray, focused: .blue, error: .red, disabled: .gray),
        borderColor: .init(idle: .black, focused: .blue, error: .red, disabled: .gray),
        descriptionColor: .init(idle: .black, focused: .black, error: .red, disabled: .gray),
        textFont: .system(size: 16),
        placeholderFont: .system(size: 12),
        descriptionFont: .system(size: 16)
    )
}

