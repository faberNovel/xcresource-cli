//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 03/05/2020.
//

import Foundation

public struct ListTemplatesCommand {

    public let namespace: String?
    private let fileManager: FileManager
    private let output: CommandOutput
    private let urlProviding: XCTemplateFolderURLProviding

    // MARK: - Life Cycle

    public init(namespace: String?,
                fileManager: FileManager,
                output: CommandOutput,
                urlProviding: XCTemplateFolderURLProviding) {
        self.namespace = namespace
        self.fileManager = fileManager
        self.output = output
        self.urlProviding = urlProviding
    }

    // MARK: - Public

    public func run() throws {
        let source: URL
        if let namespace = namespace {
            source = urlProviding.url(for: .templates(namespace: namespace))
        } else {
            source = urlProviding.url(for: .xcodeDestination)
        }
        try listTemplate(at: source, depth: 0)
        let count = (try? CountTemplatesCommand(url: source, fileManager: fileManager).countTemplates()) ?? 0
        if count == 0 {
            output.print("No template installed")
        }
    }

    // MARK: - Private

    private func listTemplate(at url: URL, depth: Int) throws {
        if url.isTemplate {
            output.print("~>", "\(url.lastPathComponent)")
        } else if url.hasDirectoryPath {
            if depth > 0 {
                let prefix = (0..<depth).reduce(into: "", { r, _ in r += "#" })
                output.print(prefix, "\(url.lastPathComponent)")
            }
            let templates = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [],
                options: .skipsHiddenFiles
            )
            try templates.forEach {
                try listTemplate(at: $0, depth: depth + 1)
            }
        }
    }
}
