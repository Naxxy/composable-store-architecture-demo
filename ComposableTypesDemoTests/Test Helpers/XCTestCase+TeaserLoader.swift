//
//  XCTestCase+Helpers.swift
//  ComposableTypesDemoTests
//

import Foundation
import XCTest
@testable import ComposableTypesDemo

// TODO: - We *could* change the `expect() -> Void` code to instead be returning the values / errors and keep the assertions in the main XCTestCase classes. For example:
//          - `resultFor(...) -> Result<Teaser, Error>
//          - `teaserFor(...) -> Teaser
//          - `errorFor(...) -> Error
//         Where the above cases call assertions/expectations with #filePath and #line to show errors if the return value could not be retrieved for some reason.

// MARK: - Testing Helpers
extension XCTestCase {
    func expect(
        _ sut: any TeaserLoader,
        onLoadWith teaserId: Int,
        toCompleteWithError action: @escaping (Error) -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, onLoadWith: teaserId, toCompleteWithResult: { result in
            switch result {
            case .success:
                XCTFail("Expected an error but found \(result) instead", file: file, line: line)
            case .failure(let error):
                action(error)
            }
        }, file: file, line: line)
    }
    
    func expect(
        _ sut: any TeaserLoader,
        onLoadWith teaserId: Int,
        toCompleteWithTeaser action: @escaping (Teaser) -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, onLoadWith: teaserId, toCompleteWithResult: { result in
            switch result {
            case .success(let data):
                action(data)
            case .failure:
                XCTFail("Unexpected error", file: file, line: line)
            }
        }, file: file, line: line)
    }
    
    func expect(
        _ sut: any TeaserLoader,
        onLoadWith teaserId: Int,
        toCompleteWithResult action: @escaping (Result<Teaser, Error>) -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "Waiting for load to complete")
        sut.load { result in
            action(result)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
    }
}

// MARK: - Value Helpers
extension XCTestCase {
    var timestamp: (iso8601: String, epochTimeInterval: TimeInterval) {
        (iso8601: "2021-08-10T01:13:07Z", epochTimeInterval: TimeInterval(1628557987))
    }
    
    var anyId: Int {
        return 0
    }
    
    var anyError: Error {
        MapperError.urlCreationFailed("anyString")
    }
    
    var anyTeaserAPILoader: TeaserAPILoader {
        TeaserAPILoader(id: anyId)
    }
    
    func makeAPITeaser(withId id: Int) -> Teaser {
        Teaser(
            id: id,
            title: "Some API Teaser Title",
            summary: "This is a teaser fetched from the API endpoint",
            imageUrl: URL(string: "https://www.abc.net.au/resources/teaser.jpg")!,
            lastUpdated: Date(timeIntervalSince1970: timestamp.epochTimeInterval)
        )
    }
    
    func makeGQLTeaser(withId id: Int) -> Teaser {
        Teaser(
            id: id,
            title: "Some GQL Teaser Title",
            summary: "This is a teaser fetched from the GQL endpoint",
            imageUrl: URL(string: "https://www.abc.net.au/resources/teaser.jpg")!,
            lastUpdated: Date(timeIntervalSince1970: timestamp.epochTimeInterval)
        )
    }
    
    func makeLoaderWithFallback(
        primaryLoader: (any TeaserLoader)? = nil,
        fallbackLoader: (any TeaserLoader)? = nil
    ) -> any TeaserLoader {
        let primary: any TeaserLoader = primaryLoader ?? TeaserGQLLoader(id: anyId)
        let fallback: any TeaserLoader = fallbackLoader ?? TeaserAPILoader(id: anyId)
        
        let compositeLoader = TeaserLoaderWithFallback(
            primaryLoader: primary,
            fallbackLoader: fallback
        )
        return compositeLoader
        
    }
}
