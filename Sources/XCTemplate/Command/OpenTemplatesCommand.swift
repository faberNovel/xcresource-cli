//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 15/05/2020.
//

import Foundation
import ArgumentParser

struct OpenTemplatesCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(
        commandName: "open",
        abstract: "Open Xcode templates folder."
    )

    func run() throws {
        let url = FileManager.default.url(for: .xcodeDestination)
        try Shell().execute(.open(path: url.path))
    }
}
