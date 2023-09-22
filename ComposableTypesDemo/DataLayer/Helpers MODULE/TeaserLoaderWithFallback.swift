//
//  TeaserLoaderWithFallback.swift
//  ComposableTypesDemo
//

import Foundation

/*
 Composite allowed because both loaders implement TeaserLoader
 
 This allows us to do lots of things like:
 - Retry on failed remote load
 - Attempt a GQL load before the API load
 - Attempt a cache load before a remote load
 
 */
class TeaserLoaderWithFallback: TeaserLoader {
    var id: Int {
        get {
            primaryLoader.id
        }
        set {
            primaryLoader.id = newValue
            fallbackLoader.id = newValue
        }
    }
    
    typealias Output = Teaser
    private var primaryLoader: any TeaserLoader
    private var fallbackLoader: any TeaserLoader
    
    init(primaryLoader: any TeaserLoader, fallbackLoader: any TeaserLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    func load(completion: @escaping (Result<Output, Error>) -> Void) {
        primaryLoader.load { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let teaser):
                completion(.success(teaser))
            case .failure:
                self.fallbackLoader.load(completion: completion)
            }
        }
    }
}
