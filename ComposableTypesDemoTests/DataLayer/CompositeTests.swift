//
//  CompositeTests.swift
//  ComposableTypesDemoTests
//

import XCTest
@testable import ComposableTypesDemo

final class CompositeTests: XCTestCase {
    func testCompositeTeaserLoader_completesWithPrimary() {
        // Given
        let expectedId = anyId
        let expectedTeaser = makeGQLTeaser(withId: expectedId)
        let sut = makeLoaderWithFallback(
            primaryLoader: TeaserGQLLoader(id: expectedId),
            fallbackLoader: TeaserAPILoader(id: expectedId)
        )
        
        // Then
        expect(sut, onLoadWith: expectedId) { teaser in
            XCTAssertEqual(teaser, expectedTeaser)
        }
    }
    
    func testCompositeTeaserLoader_completesWithSecondary() {
        // Given
        let expectedId = anyId
        let expectedTeaser = makeAPITeaser(withId: expectedId)
        let primary = TeaserGQLLoader(id: expectedId)
        let sut = makeLoaderWithFallback(
            primaryLoader: primary,
            fallbackLoader: TeaserAPILoader(id: expectedId)
        )
        
        // When
        primary.error = anyError
        
        // Then
        expect(sut, onLoadWith: expectedId) { teaser in
            XCTAssertEqual(teaser, expectedTeaser)
        }
    }
    
    func testCompositeTeaserLoader_completesWithFailure() {
        // Given
        let expectedId = anyId
        let primary = TeaserGQLLoader(id: expectedId)
        let fallback = TeaserAPILoader(id: expectedId)
        let sut = makeLoaderWithFallback(
            primaryLoader: primary,
            fallbackLoader: fallback
        )
        
        // When
        primary.error = anyError
        fallback.error = anyError
        
        // Then
        expect(sut, onLoadWith: expectedId, toCompleteWithError: { _ in })
    }
}
