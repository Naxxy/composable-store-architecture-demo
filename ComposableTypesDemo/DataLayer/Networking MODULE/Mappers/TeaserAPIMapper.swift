//
//  TeaserAPIMapper.swift
//  ComposableTypesDemo
//

import Foundation

enum TeaserAPIMapper: DataMapper {
    typealias Output = Teaser
    
    static func map(_ data: Data) throws -> Teaser {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let apiTeaser = try decoder.decode(APITeaser.self, from: data)
        
        guard let imageUrl = URL(string: apiTeaser.details.imageUrl) else {
            throw MapperError.urlCreationFailed(apiTeaser.details.imageUrl)
        }
        
        return Teaser(
            id: apiTeaser.id,
            title: apiTeaser.title,
            summary: apiTeaser.details.summary,
            imageUrl: imageUrl,
            lastUpdated: apiTeaser.details.lastUpdated
        )
    }
    
    // Remote API Structure
    private struct APITeaser: Decodable {
        let id: Int
        let title: String
        let details: APITeaserDetails
        
        struct APITeaserDetails: Decodable {
            let lastUpdated: Date
            let summary: String?
            let imageUrl: String
        }
    }
}

