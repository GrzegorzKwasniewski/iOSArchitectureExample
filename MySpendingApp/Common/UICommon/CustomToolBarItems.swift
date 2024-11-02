import SwiftUI
import Factory

extension View {
    /// Action closure has strong reference to UIKitBarButtonItem, so use `[weak object]` inside this closure
    func backBarButton(action: (() -> Void)? = nil) -> some View {
        modifier(BackBarButtonModifier(action: action))
    }

    /// Action closure has strong reference to UIKitBarButtonItem, so use `[weak object]` inside this closure
    func closeBarButton(action: (() -> Void)? = nil) -> some View {
        modifier(CloseBarButtonModifier(action: action))
    }

    /// Action closure has strong reference to UIKitBarButtonItem, so use `[weak object]` inside this closure
    func toolbarTrailingButton(text: LocalizedStringResource, opacity: CGFloat = 1, action: @escaping () -> Void) -> some View {
        modifier(TrailingToolbarButtonModifier(text: text, opacity: opacity, action: action))
    }

    func navigationBarVisible(_ visible: Bool = true) -> some View {
        modifier(NavigationBarVisibleModifier(visible: visible))
    }

    /// Remember to pin navigation back button after leading title
    func leadingNavigationTitle(_ title: LocalizedStringResource) -> some View {
        navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(title)
                        .font(.headline2Bold)
                        .foregroundStyle(.blackText)
                }
            }
    }

    /// Remember to pin navigation back button after leading title
    func leadingNavigationTitle(_ title: String) -> some View {
        navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(title)
                        .font(.headline2Bold)
                        .foregroundStyle(.blackText)
                }
            }
    }

    /// backAction closure has strong reference to UIKitBarButtonItem, so use `[weak object]` inside this closure
    func toolbarGroup(stringTitle: String, backAction: (() -> Void)? = nil) -> some View {
        navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 10) {
                        BackBarButton(action: backAction)
                        Text(stringTitle)
                            .font(.headline2Bold)
                            .foregroundStyle(.blackText)
                    }
                }
            }
    }

    /// backAction closure has strong reference to UIKitBarButtonItem, so use `[weak object]` inside this closure
    func toolbarGroup(localizedTitle: LocalizedStringResource, backAction: (() -> Void)? = nil) -> some View {
        navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 10) {
                        BackBarButton(action: backAction)
                        Text(localizedTitle)
                            .font(.headline2Bold)
                            .foregroundStyle(.blackText)
                    }
                }
            }
    }
}

private struct NavigationBarVisibleModifier: ViewModifier {
    let visible: Bool
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarBackground(visible ? .visible : .hidden, for: .navigationBar)
    }
}

private struct BackBarButtonModifier: ViewModifier {
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackBarButton(action: action)
                }
            }
    }
}

private struct CloseBarButtonModifier: ViewModifier {
    @ObservedObject var navigation: AppNavigation = Container.shared.appNavigation()
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let action {
                            action()
                        } else {
                            navigation.popToRoot()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.violetLight)

                            Image(.close)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 40, height: 40)
                    }
                }
            }
    }
}

private struct TrailingToolbarButtonModifier: ViewModifier {
    let text: LocalizedStringResource
    let opacity: CGFloat
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        action()
                    } label: {
                        Text(text)
                    }
                    .opacity(opacity)
                }
            }
    }
}

private struct BackBarButton: View {
    @ObservedObject var navigation: AppNavigation = Container.shared.appNavigation()
    let action: (() -> Void)?

    var body: some View {
        Button {
            if let action {
                action()
            } else {
                navigation.pop()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.violetLight)

                Image(.backArrow)
                    .resizable()
                    .frame(width: 10, height: 20)
            }
            .frame(width: 40, height: 40)
        }
    }
}
