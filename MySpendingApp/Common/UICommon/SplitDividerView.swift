import SwiftUI

struct SplitDividerView: View {
    var text: LocalizedStringResource = "lub"

    var body: some View {
        HStack(spacing: 8) {
            dividerView

            Text(text)
                .font(.headline4Medium)
                .foregroundStyle(.blackText)

            dividerView
        }
    }

    private var dividerView: some View {
        Rectangle()
            .fill(.greyLightActive)
            .frame(height: 1)
    }
}
