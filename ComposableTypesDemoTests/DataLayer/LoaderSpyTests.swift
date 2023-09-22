//
//  LoaderSpyTests.swift
//  ComposableTypesDemoTests
//

import XCTest
@testable import ComposableTypesDemo

final class LoaderSpyTests: XCTestCase {
    func test_teaserLoader_doesNotCallLoadOnInit() {
        let expectedMessages: [TeaserLoaderSpy.Message] = []
        let sut = TeaserLoaderSpy(loader: TeaserAPILoader(id: anyId))
        
        XCTAssertEqual(sut.messages, expectedMessages)
    }
    
    func test_teaserLoader_onlyCallsLoadOnceOnLoad() {
        let expectedId = anyId
        var expectedMessages = [TeaserLoaderSpy.Message]()
        let sut = TeaserLoaderSpy(loader: TeaserAPILoader(id: expectedId))
        
        expectedMessages.append(.load(id: expectedId))
        sut.load { _ in }
        XCTAssertEqual(sut.messages, expectedMessages)
    }
    
    func test_teaserLoader_loadsDataInCorrectOrder() {
        // Given
        let firstId = 4
        let secondId = 5
        var expectedMessages = [TeaserLoaderSpy.Message]()
        let sut = TeaserLoaderSpy(loader: TeaserAPILoader(id: anyId))
        
        expectedMessages.append(.load(id: firstId))
        expectedMessages.append(.load(id: secondId))
        
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
}

//extension TeaserLoader {
//    private func loadAfterDelay(_ delay: TimeInterval, withId id: Int, completion: Bool) {
//        let exp = expectation(description: "Waiting for load to complete")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            loader.id = secondId
//            load(completion)
//        }
//    }
//}
