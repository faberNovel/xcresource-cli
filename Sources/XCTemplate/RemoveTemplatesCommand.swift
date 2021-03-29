//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 03/05/2020.
//

import Foundation

public struct RemoveTemplatesCommand {

    public let namespace: String
    private let fileManager: FileManager
    private let urlProviding: XCTemplateFolderURLProviding

    // MARK: - Life Cycle

    public init(namespace: String,
                fileManager: FileManager,
                urlProviding: XCTemplateFolderURLProviding) {
        self.namespace = namespace
        self.fileManager = fileManager
        self.urlProviding = urlProviding
    }

    // MARK: - Public

    public func run() throws {
        try fileManager.removeItem(at: urlProviding.url(for: .templates(namespace: namespace)))
    }
}
