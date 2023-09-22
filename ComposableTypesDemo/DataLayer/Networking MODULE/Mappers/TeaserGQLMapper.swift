//
//  TeaserGQLMapper.swift
//  ComposableTypesDemo
//

import Foundation

enum TeaserGQLMapper: DataMapper {
    typealias Output = Teaser
    
    static func map(_ data: Data) throws -> Teaser {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let gqlTeaser = try decoder.decode(GQLTeaser.self, from: data)
        
        guard let imageUrl = URL(string: gqlTeaser.imageUrl) else {
            throw MapperError.urlCreationFailed(gqlTeaser.imageUrl)
        }
        
        return Teaser(
            id: gqlTeaser.id,
            title: gqlTeaser.title,
            summary: gqlTeaser.summary,
            imageUrl: imageUrl,
            lastUpdated: gqlTeaser.lastUpdated
        )
    }
    
    // Remote API Structure
    private struct GQLTeaser: Decodable {
        let id: Int
        let title: String
        let lastUpdated: Date
        let summary: String?
        let imageUrl: String
    }
}

