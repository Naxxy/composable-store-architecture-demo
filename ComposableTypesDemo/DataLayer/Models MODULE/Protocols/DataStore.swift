//
//  DataStore.swift
//  ComposableTypesDemo
//

import Foundation

/*
 Loading and Caching are separate responsibilities.
 
 Sharing a Loading protocol allows for Remote loading AND local loading regardless of load method.
 
 Since most cache sources will also allow us to retrieve what we save then we can just
    implement both protocols using the TeaserStore typealias
 */
typealias DataStore = DataLoader & DataCache

protocol DataLoader {
    associatedtype Output
    typealias Result = Swift.Result<Output, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

protocol DataCache {
    associatedtype Output
    func save(_ item: Output) throws
}
