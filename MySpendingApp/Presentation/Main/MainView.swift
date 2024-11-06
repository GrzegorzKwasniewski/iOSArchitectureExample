import SwiftUI
import Factory

struct MainView: View {
    var body: some View {
        HeaderView(title: "Main view")
    }
}

extension ViewFactory {
    static var main: MainView {
        Container.shared.mainView()
    }
}

#Preview {
    ViewFactory.main
}
