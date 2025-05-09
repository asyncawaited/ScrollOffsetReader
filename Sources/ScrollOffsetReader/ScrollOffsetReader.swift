// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

/// MARK: - ScrollOffsetReader Component
public struct ScrollOffsetReader<Content: View>: View {
    public let axes: Axis.Set
    public let showsIndicators: Bool
    public let sampleInterval: TimeInterval
    public let minDifference: CGFloat
    @Binding public var scrollOffset: CGSize
    private let coordinateSpaceName: String
    private let content: Content

    public init(scrollOffset: Binding<CGSize>,
                axes: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                sampleInterval: TimeInterval = 0.25,
                minDifference: CGFloat = 2.0,
                @ViewBuilder content: () -> Content) {
        self._scrollOffset = scrollOffset
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.sampleInterval = sampleInterval
        self.minDifference = minDifference
        self.coordinateSpaceName = UUID().uuidString
        self.content = content()
    }

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ZStack {
                content
                ScrollOffsetProxy(name: coordinateSpaceName)
            }
        }
        .modifier(ScrollOffsetModifier(offset: $scrollOffset,
                                       coordinateSpaceName: coordinateSpaceName,
                                       sampleInterval: sampleInterval,
                                       minDifference: minDifference))
    }
}
