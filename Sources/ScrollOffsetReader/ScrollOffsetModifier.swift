//
//  ScrollOffsetModifier.swift
//  ScrollOffsetReader
//
//  Created by Royal on 2025/5/8.
//

import SwiftUI
import Combine

struct ScrollOffsetModifier: ViewModifier {
    @Binding var offset: CGSize
    let coordinateSpaceName: String
    @StateObject private var sampler: OffsetSampler

    init(offset: Binding<CGSize>,
         coordinateSpaceName: String,
         sampleInterval: TimeInterval,
         minDifference: CGFloat) {
        self._offset = offset
        self.coordinateSpaceName = coordinateSpaceName
        self._sampler = StateObject(wrappedValue: OffsetSampler(sampleInterval: sampleInterval,
                                                                minDifference: minDifference))
    }

    func body(content: Content) -> some View {
        content
            .coordinateSpace(name: coordinateSpaceName)
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                sampler.update(offset: value)
            }
            .onReceive(sampler.$sampledOffset) { value in
                offset = value
            }
    }
}
