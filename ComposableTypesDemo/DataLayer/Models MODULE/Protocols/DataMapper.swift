//
//  DataMapper.swift
//  ComposableTypesDemo
//

import Foundation

/*
 We want to separate mappers from data.
 
 If we don't separate the mappers from the data then our data models become tighly coupled with the infrastructure/source

 So, for example, our Teaser would be coupled with the codable implementation, which means it's coupled with ONE SPECIFIC way of mapping from some store.
    i.e. Our teaser is based on the API V3 implementation of teaser, and can't be decoded from API V2 or GQL implementations
 
 This also means that when the (network or cache) source changes, the model needs to change.
    And since the rest of the app depends on the model then we have one infrastructure detail causing an app-wide refactor

 It also means that we can't easily map from multiple stores into the data model.
    And it makes it more difficult to create the data models since we need to create them from stubs instead of just instantiating the values for the models as simple data containers.
 */
protocol DataMapper {
    associatedtype Output
    static func map(_ data: Data) throws -> Output
}

enum MapperError: Error {
    case noItemFound(Int)
    case urlCreationFailed(String)
}

