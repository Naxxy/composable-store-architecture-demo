//
//  Teaser.swift
//  ComposableTypesDemo
//

import Foundation

typealias TeaserStore = TeaserLoader & TeaserCache
protocol TeaserCache: DataCache where Output == Teaser { }
protocol TeaserLoader: DataLoader where Output == Teaser {
    var id: Int { get set }
}

// With pure data models you get Equatable and Hashable for free!
struct Teaser: Equatable, Hashable {
    let id: Int
    let title: String
    let summary: String?
    let imageUrl: URL
    let lastUpdated: Date
}
