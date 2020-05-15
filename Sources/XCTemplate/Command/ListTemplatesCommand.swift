//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 03/05/2020.
//

import Foundation
import ArgumentParser

struct ListTemplatesCommand: ParsableCommand {

    @Option(
        name: .shortAndLong,
        help: "The template namespace to list. All namespaces are listed if not specified."
    )
    var namespace: String?

    public static let configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List Xcode templates."
    )

    private var fileManager: FileManager { .default }

    // MARK: - ParsableCommand

    func run() throws {
        let source: URL
        if let namespace = namespace {
            source = fileManager.url(for: .templates(namespace: namespace))
        } else {
            source = fileManager.url(for: .xcodeDestination)
        }
        try listTemplate(at: source, depth: 0)
        let count = (try? CountTemplatesCommand(url: source).countTemplates()) ?? 0
        if count == 0 {
            print("No template installed")
        }
    }

    private func listTemplate(at url: URL, depth: Int) throws {
        if url.isTemplate {
            print("~>", "\(url.lastPathComponent)")
        } else if url.hasDirectoryPath {
            if depth > 0 {
                let prefix = (0..<depth).reduce(into: "", { r, _ in r += "#" })
                print(prefix, "\(url.lastPathComponent)")
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
