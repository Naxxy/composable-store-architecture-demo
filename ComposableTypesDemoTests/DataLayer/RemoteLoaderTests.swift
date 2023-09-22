//
//  RemoteLoaderTests.swift
//  ComposableTypesDemoTests
//

import XCTest
@testable import ComposableTypesDemo

// TODO: Change expect() -> Void method to be let value = valueFor() -> Value 
final class RemoteLoaderTests: XCTestCase {
    func test_APIFetch_completesWithTeaserWhenNoError() throws {
        let expectedId = anyId
        let sut = TeaserAPILoader(id: expectedId)
        let expected = makeAPITeaser(withId: expectedId)
        
        expect(sut, onLoadWith: expectedId, toCompleteWithTeaser: { teaser in
            XCTAssertEqual(teaser, expected)
        })
    }
    
    func test_APIFetch_completesWithErrorWhenErrorIsSet() throws {
        let expectedId = anyId
        let sut = TeaserAPILoader(id: expectedId)
        
        // When
        sut.error = anyError
        
        // Then
        // TODO: Add assertion for specfic error
        expect(sut, onLoadWith: expectedId, toCompleteWithError: { _ in })
    }
    
    func test_GQLFetch_completesWithTeaserWhenNoError() throws {
        let expectedId = anyId
        let sut = TeaserGQLLoader(id: expectedId)
        let expected = makeGQLTeaser(withId: expectedId)
        
        expect(sut, onLoadWith: expectedId, toCompleteWithTeaser: { teaser in
            XCTAssertEqual(teaser, expected)
        })
    }
    
    func test_GQLFetch_completesWithErrorWhenErrorIsSet() throws {
        let expectedId = anyId
        let sut = TeaserGQLLoader(id: expectedId)

        // When
        sut.error = anyError
        
        // Then
        // TODO: Add assertion for specfic error
        expect(sut, onLoadWith: expectedId, toCompleteWithError: { _ in })
    }
}
