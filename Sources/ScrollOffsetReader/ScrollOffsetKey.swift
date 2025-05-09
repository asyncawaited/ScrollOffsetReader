//
//  ScrollOffsetKey.swift
//  ScrollOffsetReader
//
//  Created by Royal on 2025/5/8.
//

import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
