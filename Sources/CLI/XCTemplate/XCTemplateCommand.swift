
import Foundation
import ArgumentParser

struct XCTemplateCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "template",
        abstract: "A command to manage Xcode templates.",
        subcommands: [
            InstallTemplatesCommand.self,
            RemoveTemplatesCommand.self,
            ListTemplatesCommand.self,
            OpenTemplatesCommand.self
        ]
    )
}
