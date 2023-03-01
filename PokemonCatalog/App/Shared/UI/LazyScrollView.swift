import SwiftUI

// MARK: - Model

struct LazyVScrollView<Content: View> {
    private let content: Content
    private let id = UUID()
    private let action: () -> Void
    private let margin: CGFloat

    @State private var isNearBottom = false

    init(nearBottomMargin margin: CGFloat = .zero, content: () -> Content, onNearBottom action: @escaping () -> Void) {
        self.content = content()
        self.action = action
        self.margin = margin
    }
}

// MARK: - View

extension LazyVScrollView: View {
    var body: some View {
        GeometryReader { outer in
            ScrollView {
                content
                    .background(
                        GeometryReader { inner in
                            Color.clear
                                .onChange(of: inner.frame(in: .named(id))) { newValue in
                                    callActionIfNear(newValue, outer: outer, inner: inner)
                                }
                        }
                    )
            }
            .coordinateSpace(name: id)
        }
    }

    private func callActionIfNear(_ rect: CGRect, outer: GeometryProxy, inner: GeometryProxy) {
        let previouslyNearBottom = isNearBottom
        isNearBottom = (rect.maxY - outer.frame(in: .global).height) < margin

        if isNearBottom, !previouslyNearBottom {
            action()
        }
    }
}
