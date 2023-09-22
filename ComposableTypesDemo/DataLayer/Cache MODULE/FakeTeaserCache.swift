//
//  FakeTeaserCache.swift
//  ComposableTypesDemo
//

import Foundation

// Just an in-memory cache for testing store loading
class FakeTeaserCache: TeaserStore {
    typealias Output = Teaser
    
    private var store = [Int: Output]()
    
    var id: Int
    init(id: Int) {
        self.id = id
    }
    
    func load(completion: @escaping (Result<Output, Error>) -> Void) {
        guard let teaser = store[id] else {
            completion(.failure(MapperError.noItemFound(id)))
            return
        }
        
        completion(.success(teaser))
    }
    
    func save(_ item: Output) throws {
        store[item.id] = item
    }
}
