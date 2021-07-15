
import Foundation
import ArgumentParser

struct XCTemplateCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "template",
        subcommands: [
            InstallTemplatesCommand.self,
            RemoveTemplatesCommand.self,
            ListTemplatesCommand.self,
            OpenTemplatesCommand.self
        ]
    )
}
