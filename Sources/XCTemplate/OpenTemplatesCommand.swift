//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 15/05/2020.
//

import Foundation

public struct OpenTemplatesCommand {

    private let urlProvider: XCTemplateFolderURLProviding

    // MARK: - Life Cycle

    public init(urlProvider: XCTemplateFolderURLProviding) {
        self.urlProvider = urlProvider
    }

    // MARK: - Public

    public func run() throws {
        let url = urlProvider.url(for: .xcodeDestination)
        try Shell().execute(.open(path: url.path))
    }
}
