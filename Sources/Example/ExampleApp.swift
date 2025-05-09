//
//  ExampleApp.swift
//  ScrollOffsetReader
//
//  Created by Royal on 2025/5/8.
//

import SwiftUI
import ScrollOffsetReader

@main
struct ExampleApp: App {
    @State private var offset = CGSize.zero
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Text("Offset: \(offset.width), \(offset.height)")
                ScrollOffsetReader(scrollOffset: $offset) {
                    VStack {
                        ForEach(0..<100) { i in
                            Text("Row \(i)").frame(maxWidth: .infinity).padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
