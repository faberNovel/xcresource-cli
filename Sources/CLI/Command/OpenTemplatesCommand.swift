//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 15/05/2020.
//

import Foundation
import ArgumentParser
import XCTemplate

struct OpenTemplatesCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(
        commandName: "open",
        abstract: "Open Xcode templates folder."
    )

    private var fileManager: FileManager { .default }

    func run() throws {
        try XCTemplate.OpenTemplatesCommand(
            urlProvider: fileManager
        )
        .run()
    }
}
