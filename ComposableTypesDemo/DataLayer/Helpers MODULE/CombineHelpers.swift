//
//  CombineHelpers.swift
//  ComposableTypesDemo
//

import Foundation
import Combine

// Loader publisher
extension TeaserLoader {
    var publisher: AnyPublisher<Output, Error> {
        return Future { callback in
            self.load(completion: callback)
        }
        .eraseToAnyPublisher()
    }
}

// Cache operator
extension Publisher where Output == Teaser {
    func caching(to cache: any TeaserCache) -> AnyPublisher<Output, Error> {
        self.tryMap { teaser in
            try cache.save(teaser)
            return teaser
        }
        .eraseToAnyPublisher()
    }
}

// Fallback
extension Publisher where Output == Teaser {
    func withFallback(
        _ fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>
    ) -> AnyPublisher<Output, Failure> {
        self.catch { _ in
            fallbackPublisher()
        }
        .eraseToAnyPublisher()
    }
}
