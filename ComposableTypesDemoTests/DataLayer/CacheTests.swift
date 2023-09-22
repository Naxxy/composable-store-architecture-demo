//
//  CacheTests.swift
//  ComposableTypesDemoTests
//

import XCTest
@testable import ComposableTypesDemo

final class CacheTests: XCTestCase {
    func testCacheTeaser() throws {
        let expectedId = anyId
        let sut = FakeTeaserCache(id: expectedId)
        let expectedTeaser = makeAPITeaser(withId: expectedId)
        
        expect(sut, onLoadWith: expectedId, toCompleteWithError: { _ in })
        
        XCTAssertNoThrow(try sut.save(expectedTeaser))
        
        expect(sut, onLoadWith: expectedId, toCompleteWithTeaser: { teaser in
            XCTAssertEqual(teaser, expectedTeaser)
        })
    }
}
