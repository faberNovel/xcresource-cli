//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 07/07/2021.
//

import Foundation

class XCSnippetsDownloader {

    let fileManager: FileManager
    let snippetFileManager: XCSnippetFileManager
    let strategyFactory: XCSnippetDownloadingStrategyFactory

    init(fileManager: FileManager,
         snippetFileManager: XCSnippetFileManager,
         strategyFactory: XCSnippetDownloadingStrategyFactory) {
        self.fileManager = fileManager
        self.snippetFileManager = snippetFileManager
        self.strategyFactory = strategyFactory
    }

    // MARK: - Public

    func downloadSnippets(at destination: URL,
                          from source: XCSnippetSource,
                          namespace: XCSnippetNamespace) throws {
        let tmp = try fileManager.createTemporarySubdirectory()
        defer {
            try? fileManager.removeItem(at: tmp)
        }
        try strategyFactory.makeStrategy(source: source).download(to: tmp)
        try snippetFileManager.tagSnippets(at: tmp, tag: try namespace.toTag())
        try snippetFileManager.removeSnippets(with: try namespace.toTag(), at: destination)
        try snippetFileManager.copySnippets(at: tmp, to: destination)
    }
}

private extension XCSnippetFile.Tag {

    var toNamespace: XCSnippetNamespace {
        SnippetFileTagToSnippetNamespaceMapper().map(self)
    }
}

private extension XCSnippetNamespace {

    func toTag() throws -> XCSnippetFile.Tag {
        try SnippetNamespaceToSnippetFileTagMapper().map(self)
    }
}
