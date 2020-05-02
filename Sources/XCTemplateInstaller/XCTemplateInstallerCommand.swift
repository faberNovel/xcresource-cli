//
//  XCTemplateInstallerCommand.swift
//
//
//  Created by Gaétan Zanella on 30/04/2020.
//

import Foundation
import ArgumentParser

struct XCTemplateInstallerCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to manage Xcode templates",
        subcommands: [InstallTemplatesCommand.self]
    )
}
