//
//  PublisherExtensions.swift
//  ScrollOffsetReader
//
//  Created by Royal on 2025/5/8.
//

import Combine

extension Publisher where Failure == Never {
    /// Samples the upstream publisher whenever `trigger` emits, taking the latest value.
    func sample<T: Publisher>(with trigger: T) -> AnyPublisher<Output, Failure> where T.Failure == Never {
        trigger
            .flatMap { _ in self.prefix(1) }
            .eraseToAnyPublisher()
    }
}
