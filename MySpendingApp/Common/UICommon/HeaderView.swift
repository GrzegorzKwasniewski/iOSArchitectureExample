import SwiftUI

struct HeaderView: View {
    let title: LocalizedStringResource
    var message: LocalizedStringResource?

    var body: some View {
        VStack(spacing: 24) {
            Image(.appleLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 60)

            Group {
                Text(title)
                    .font(.headline2Bold)
                    .foregroundStyle(.blackText)
                    .padding(.horizontal)

                if let message {
                    Text(message)
                        .font(.textBody4)
                        .foregroundStyle(.greyText)
                        .padding(.top, 16)
                }
            }
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
