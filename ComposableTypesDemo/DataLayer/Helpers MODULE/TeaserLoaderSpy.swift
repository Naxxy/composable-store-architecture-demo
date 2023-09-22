//
//  TeaserLoaderSpy.swift
//  ComposableTypesDemo
//

import Foundation

/*
 
 This spy works by capturing the messages passed to it and then forwarding it onto the wrapped loader
 
 This allows us to do things like:
 - Check that we don't have duplicate function calls in our app
 - Check that the order of function calls is correct (i.e. test against race conditions)
 
 It can also be used to capture the completion closure for later invocation to clean up testing structure,
    but I'll leave that case for now.
 
 */
class TeaserLoaderSpy: TeaserLoader {
    typealias Output = Teaser
    
    private var wrappedLoader: any TeaserLoader
    private(set) var messages: [Message] = [Message]()
    
    var id: Int {
        get {
            wrappedLoader.id
        } set {
            wrappedLoader.id = newValue
        }
    }
    
    init(loader: any TeaserLoader) {
        self.wrappedLoader = loader
    }
    
    func load(completion: @escaping (Result<Output, Error>) -> Void) {
        // Record the call info / message
        self.messages.append(Message.load(id: wrappedLoader.id))
        
        // Forward the call to the wrapped loader
        wrappedLoader.load(completion: completion)
    }
    
    enum Message: Equatable {
        case load(id: Int)
    }
}
