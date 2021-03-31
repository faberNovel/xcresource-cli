
import Foundation
import ArgumentParser

struct XCTemplateCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "xctemplate",
        abstract: "A Swift command-line tool to manage Xcode templates.",
        subcommands: [
            InstallTemplatesCommand.self,
            RemoveTemplatesCommand.self,
            ListTemplatesCommand.self,
            OpenTemplatesCommand.self
        ]
    )
}
