//
//  LoaderSpyTests.swift
//  ComposableTypesDemoTests
//

import XCTest
@testable import ComposableTypesDemo

final class LoaderSpyTests: XCTestCase {
    
    // Check that we're not making any calls before we call load() - only load(), and not init, should trigger load calls
    func test_teaserLoader_doesNotCallLoadOnInit() {
        let sut = TeaserLoaderSpy(loader: anyTeaserAPILoader)
        let expectedMessages: [TeaserLoaderSpy.Message] = []
        
        XCTAssertEqual(sut.messages, expectedMessages)
    }
    
    // Check the number of calls to make sure we're making multiple calls
    func test_teaserLoader_onlyCallsLoadOnceOnLoad() {
        let expectedId = anyId
        let sut = TeaserLoaderSpy(loader: anyTeaserAPILoader)
        let expectedMessages: [TeaserLoaderSpy.Message] = [
            .load(id: expectedId)
        ]
        
        sut.id = expectedId
        sut.load { _ in }
        
        XCTAssertEqual(sut.messages, expectedMessages)
    }
    
    // TODO: Fix the way we handle IDs - we shouldn't need to init with anyId if we're settings ids later.
    // Check for call order to match execution order - good for race condition checks?
    func test_teaserLoader_loadsAsynchronousRequestAfterSynchronousRequest() {
        // Given
        let firstId = 4
        let secondId = 5
        let sut = TeaserLoaderSpy(loader: anyTeaserAPILoader)
        var expectedMessages: [TeaserLoaderSpy.Message] = [
            .load(id: firstId),
            .load(id: secondId)
        ]
        
        // When
        let exp = expectation(description: "Waiting for load to complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sut.id = secondId
            sut.load { _ in exp.fulfill() }
        }
        
        sut.id = firstId
        sut.load { _ in }
        
        wait(for: [exp], timeout: 1.0)
        
        // Then
        XCTAssertEqual(sut.messages, expectedMessages)
    }
    
    func test_teaserLoader_loadsSynchronousRequestsInOrder() {
        // Given
        let firstId = 4
        let secondId = 5
        let sut = TeaserLoaderSpy(loader: anyTeaserAPILoader)
        var expectedMessages: [TeaserLoaderSpy.Message] = [
            .load(id: firstId),
            .load(id: secondId)
        ]
        
        // When
        sut.id = firstId
        sut.load { _ in }
        
        sut.id = secondId
        sut.load { _ in }
        
        // Then
        XCTAssertEqual(sut.messages, expectedMessages)
    }
}
