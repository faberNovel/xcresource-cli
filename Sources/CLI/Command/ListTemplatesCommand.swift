//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 03/05/2020.
//

import Foundation
import ArgumentParser
import XCTemplate

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
        try XCTemplate.ListTemplatesCommand(
            namespace: namespace,
            fileManager: fileManager,
            output: CLIOutput(),
            urlProviding: fileManager
        )
        .run()
    }
}
