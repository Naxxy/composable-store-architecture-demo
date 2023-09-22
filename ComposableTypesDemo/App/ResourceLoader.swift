//
//  ResourceLoader.swift
//  ComposableTypesDemo
//

import Foundation
import Combine

/*
 TODO: Demo Improvements
 - Use DataLoader instead of TeaserLoader to decouple data fetching from data mapping
 - Make the fallback operator work when we have AnyPublisher<Data, Error>
 - Refactor to a better solution than injection of id for loading?
 */

enum Demo {
    func makeLoader(withId id: Int) -> AnyPublisher<Teaser, Error> {
        let feedStore = FakeTeaserCache(id: id)
        return feedStore.publisher
            .withFallback { // <-- Composition possible because of shared protocol
                            //         and ISP from SOLID means we can preserve functionality
                            //         while using cache / loader / in memory / fake / spy / logger etc. and preserve functionality
                TeaserGQLLoader(id: id)
                    .logging()    // <-- Could use ABC Logger package by Adam Wareing instead of decorator
                    .publisher
//                    .map(TeaserAPIMapper.map)     // <-- This decouples Loader from transformation to the store type
                    .caching(to: feedStore)
                    .eraseToAnyPublisher()
            }
            .withFallback {
                TeaserAPILoader(id: id)
                    .publisher
//                    .map(TeaserGQLMapper.map)     // <-- This decouples Loader from transformation to the store type
                    .caching(to: feedStore)
                    .eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.global())  // <-- Loader fetching & mapping can be sync, then scheduled on background thread and received on main thread
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
