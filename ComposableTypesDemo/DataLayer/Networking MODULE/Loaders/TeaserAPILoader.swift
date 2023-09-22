//
//  TeaserAPILoader.swift
//  ComposableTypesDemo
//

import Foundation

class TeaserAPILoader: TeaserLoader {
    typealias Output = Teaser
    
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var error: Swift.Error? = nil
    func load(completion: @escaping (Result<Output, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            
            if let error {
                completion(.failure(error))
                return
            }
            
            let stubResponse = Stubs.makeAPITeaserStub(withId: id).data(using: .utf8)!
            
            do {
                let teaser = try TeaserAPIMapper.map(stubResponse)
                completion(.success(teaser))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

