import SwiftUI

public struct FloatingTextField: View {
    // MARK: - PUBLIC PROPERTIES

    let placeholder: LocalizedStringResource
    let description: LocalizedStringResource?
    @Binding var text: String
    @Binding var errorMessage: LocalizedStringResource?

    // MARK: - PRIVATE PROPERTIES

    private let isSecure: Bool
    private let prefix: String?
    @State private var viewState = FloatingFieldState.idle
    @State private var isShowingPassword: Bool = false
    @FocusState private var isFocused: Bool
    @FocusState private var secureFocus: FloatingSecureFocus?
    @Environment(\.floatingFieldStyle) private var style
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.validationInvoker) private var validationInvoker: Bool
    private let validationStorage = ValidationStorage()

    // MARK: - INITIALIZES

    public init(isSecure: Bool = false,
         prefix: String? = nil,
         placeholder: LocalizedStringResource,
         description: LocalizedStringResource? = nil,
         text: Binding<String>,
         errorMessage: Binding<LocalizedStringResource?>)
    {
        self.isSecure = isSecure
        self.prefix = prefix
        self.placeholder = placeholder
        self.description = description
        _text = text
        _errorMessage = errorMessage
    }

    public var body: some View {
        VStack(spacing: 6) {
            inputView
                .onTapGesture {
                    isFocused = true
                }
                .overlay(alignment: .trailing, content: {
                    eyeButton
                })

            descriptionView
        }
        .onChange(of: errorMessage) { errorMessage in
            if errorMessage == nil {
                viewState = isFocused ? .focused : .idle
            } else {
                viewState = .error
            }
        }
        .onChange(of: validationInvoker) { invoker in
            if invoker {
                validate()
            }
        }
        .onChange(of: isEnabled) { isEnabled in
            viewState = isEnabled ? .idle : .disabled
        }
        .onAppear {
            viewState = isEnabled ? .idle : .disabled
        }
    }

    private var inputView: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .foregroundStyle(viewState.placeholderColor(style, textEmpty: text.isEmpty))
                .font(text.isEmpty ? style.textFont : style.placeholderFont)
                .offset(x: prefix == nil ? 0 : (text.isEmpty ? 35 : 0),
                        y: text.isEmpty ? 0 : -10)
                .animation(.easeIn(duration: 0.15), value: text.isEmpty)

            fieldView
                .focused($isFocused)
                .foregroundStyle(viewState.textColor(style))
                .font(style.textFont)
                .offset(x: 0,
                        y: text.isEmpty ? 0 : 10)
                .animation(.easeIn(duration: 0.15), value: text.isEmpty)
                .onChange(of: isFocused) { isFocused in
                    if isFocused {
                        viewState = .focused
                    } else if viewState != .error {
                        viewState = .idle
                    }
                    if !isFocused {
                        validate()
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .padding(.horizontal)
        .padding(.trailing, isSecure ? 40 : 0)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(viewState.backgroundColor(style))
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(viewState.borderColor(style), lineWidth: 1.5)
        }
    }

    @ViewBuilder
    private var fieldView: some View {
        if isSecure {
            Group {
                if isShowingPassword {
                    TextField("", text: $text)
                        .focused($secureFocus, equals: .text)
                } else {
                    SecureField("", text: $text)
                        .focused($secureFocus, equals: .password)
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onChange(of: isShowingPassword) { isShowingPassword in
                secureFocus = isShowingPassword ? .text : .password
            }
        } else {
            HStack(spacing: 5) {
                if let prefix {
                    Text(prefix)
                        .foregroundStyle(style.textColor.disabled)
                    Divider()
                        .padding(.vertical)
                        .padding(.horizontal, 5)
                }
                TextField("", text: $text)
            }
        }
    }

    @ViewBuilder
    private var descriptionView: some View {
        if let text = errorMessage ?? description {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(style.descriptionFont)
                .foregroundStyle(viewState.descriptionColor(style))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var eyeButton: some View {
        if isSecure {
            Button(action: {
                isShowingPassword.toggle()
            }, label: {
                Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                    .foregroundStyle(style.borderColor.idle)
                    .padding()
            })
        }
    }

    private func validate() {
        guard !validationStorage.validators.isEmpty else {
            return
        }
        let (isValid, message) = validationStorage.validate()
        if isValid {
            errorMessage = nil
            viewState = isFocused ? .focused : .idle
        } else {
            errorMessage = message
            viewState = .error
        }
    }
}

// MARK: - VALIDATION

public extension FloatingTextField {
    func addValidator(_ validators: FloatFieldValidator...) -> some View {
        validators.forEach { $0.text = text }
        validationStorage.addValidators(validators)
        return preference(key: ValidationPreferenceKey.self, value: validators)
    }
}

// MARK: - PREVIEW MOCK

private struct FloatingViews_Mock: View {
    @State var email = ""
    @State var password = "123123123123123123123123123123123123123"
    @State var phoneNumber = "544"
    @State var emailError: LocalizedStringResource?
    @State var passDisabled = false

    var body: some View {
        VStack(spacing: 20) {
            FloatingTextField(placeholder: "Email", text: $email, errorMessage: $emailError)
                .addValidator(EmptyFieldValidator(message: "Field is empty"),
                              EmailValidator(message: "Email is not valid"))
                .onChange(of: email) { newValue in
                    passDisabled = newValue != "Test"
                }

            FloatingTextField(isSecure: true, placeholder: "Password", text: $password, errorMessage: .constant(nil))
                .disabled(passDisabled)

            FloatingTextField(prefix: "+1", placeholder: "Phone number", text: $phoneNumber, errorMessage: .constant(nil))
                .disabled(passDisabled)

            FloatingTextField(prefix: "+1", placeholder: "Phone number", text: .constant(""), errorMessage: .constant(nil))
                .disabled(passDisabled)

        }.padding(.horizontal)
    }
}

#Preview {
    FloatingViews_Mock()
}
