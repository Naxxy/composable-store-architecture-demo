//
//  TeaserLogger.swift
//  ComposableTypesDemo
//

import Foundation
import os.log

class TeaserLogger: TeaserLoader {
    typealias Output = Teaser

    private var wrappedLoader: any TeaserLoader
    private let log: OSLog

    var id: Int {
        get {
            wrappedLoader.id
        }
        set {
            wrappedLoader.id = newValue
        }
    }

    init(
        loader: any TeaserLoader,
        log: OSLog = OSLog(subsystem: "com.example.ComposableTypesDemo", category: "TeaserLogger")
    ) {
        self.log = log
        self.wrappedLoader = loader
    }
    
    func load(completion: @escaping (Result<Output, Error>) -> Void) {
        let startTime = Date()
        wrappedLoader.load { result in
            let endTime = Date()
            let elapsedTime = endTime.timeIntervalSince(startTime)
            
            os_log("Loading teaser with ID: %d took %f seconds", log: self.log, type: .info, self.id, elapsedTime)
            
            completion(result)
        }
    }
}

extension TeaserLoader {
    func logging(withLog log: OSLog? = nil) -> any TeaserLoader {
        guard let log else {
            return TeaserLogger(loader: self)
        }
        return TeaserLogger(loader: self, log: log)
    }
}
