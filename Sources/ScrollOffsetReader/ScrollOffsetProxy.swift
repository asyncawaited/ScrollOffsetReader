//
//  ScrollOffsetProxy.swift
//  ScrollOffsetReader
//
//  Created by Royal on 2025/5/8.
//

import SwiftUI

struct ScrollOffsetProxy: View {
    let name: String

    var body: some View {
        GeometryReader { proxy in
            let offset = CGSize(
                width:  proxy.frame(in: .named(name)).minX,
                height: proxy.frame(in: .named(name)).minY
            )
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: offset)
        }
    }
}

