import SwiftUI

// MARK: - View Components

struct PrimaryButton: View {
    let title: LocalizedStringResource
    let maxWidth: CGFloat?
    let action: () -> Void

    init(title: LocalizedStringResource, maxWidth: CGFloat? = .infinity, action: @escaping () -> Void) {
        self.title = title
        self.maxWidth = maxWidth
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Text(title)
                Image(systemName: "arrow.right")
            }
        }
        .buttonStyle(PrimaryButtonStyle(maxWidth: maxWidth))
    }
}

struct TertiaryButton: View {
    let title: LocalizedStringResource
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Text(title)
                Image(systemName: "arrow.right")
            }
        }
        .buttonStyle(TertiaryButtonStyle())
    }
}

struct UnderlinedButton: View {
    let title: LocalizedStringResource
    var alignment: Alignment = .center
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
        })
        .buttonStyle(UnderlineButtonStyle(alignment: alignment))
    }
}

struct SheetCloseButton: View {
    @Binding var toggle: Bool

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                toggle.toggle()
            }) {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
                    .padding()
                    .padding(.top)
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    let maxWidth: CGFloat?

    init(maxWidth: CGFloat? = .infinity) {
        self.maxWidth = maxWidth
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.textBody3)
            .foregroundStyle(isEnabled ? .whiteBG : .greyNormal)
            .padding(15)
            .frame(maxWidth: maxWidth)
            .background(isEnabled ? .violetLightActive : .greyLightActive)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct TertiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.textBody3)
            .foregroundStyle(.violetNormalPrimary)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.violetNormalPrimary, lineWidth: 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct UnderlineButtonStyle: ButtonStyle {
    let alignment: Alignment

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold))
            .underline(pattern: .solid, color: .blackText)
            .padding(.vertical, 5)
            .foregroundStyle(.blackText)
            .frame(maxWidth: .infinity, alignment: alignment)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        PrimaryButton(title: "PrimaryButton") {}
        PrimaryButton(title: "PrimaryButton disabled") {}
            .disabled(true)
        TertiaryButton(title: "TertiaryButton") {}
        UnderlinedButton(title: "UnderlinedButton Center") {}
        UnderlinedButton(title: "UnderlinedButton Leading", alignment: .leading) {}
    }
    .padding(.horizontal)
}
