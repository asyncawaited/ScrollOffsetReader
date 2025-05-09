//
//  OffsetSampler.swift
//  ScrollOffsetReader
//
//  Created by Royal on 2025/5/8.
//

import Combine
import SwiftUI

@MainActor
final class OffsetSampler: ObservableObject {
    @Published var sampledOffset: CGSize = .zero

    private var cancellables = Set<AnyCancellable>()
    private let offsetSubject = CurrentValueSubject<CGSize, Never>(.zero)
    private var lastSentOffset: CGSize = .zero
    private let minDifference: CGFloat
    private let sampleInterval: TimeInterval

    init(sampleInterval: TimeInterval = 0.25,
         minDifference: CGFloat = 2.0) {
        self.sampleInterval = sampleInterval
        self.minDifference = minDifference

        offsetSubject
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .sample(with: Timer.publish(every: sampleInterval, on: .main, in: .common).autoconnect())
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] offset in
                self?.sampledOffset = offset
            }
            .store(in: &cancellables)
    }

    func update(offset: CGSize) {
        // 这里已经在 MainActor 上了，不用再手动 dispatch
        let dx = abs(offset.width  - self.lastSentOffset.width)
        let dy = abs(offset.height - self.lastSentOffset.height)
        guard dx >= minDifference || dy >= minDifference else { return }

        self.lastSentOffset = offset
        self.offsetSubject.send(offset)
    }
}
