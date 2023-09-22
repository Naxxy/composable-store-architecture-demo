//
//  Stubs.swift
//  ComposableTypesDemo
//
//  Created by Ashar Guglielmino on 20/9/2023.
//

import Foundation

enum Stubs {
    static func makeAPITeaserStub(withId teaserId: Int) -> String {
        return """
            {
                "id": \(teaserId),
                "title": "Some API Teaser Title",
                "details": {
                    "last_updated": "2021-08-10T01:13:07Z",
                    "summary": "This is a teaser fetched from the API endpoint",
                    "image_url": "https://www.abc.net.au/resources/teaser.jpg"
                }
            }
        """
    }
    
    static func makeGQLTeaserStub(withId teaserId: Int) -> String {
        return """
            {
                "id": \(teaserId),
                "title": "Some GQL Teaser Title",
                "last_updated": "2021-08-10T01:13:07Z",
                "summary": "This is a teaser fetched from the GQL endpoint",
                "image_url": "https://www.abc.net.au/resources/teaser.jpg"
            }
        """
    }
}
