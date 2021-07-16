
import Foundation
import ArgumentParser

struct XCResourceCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "xcresource",
        abstract: "A command-line tool to manage Xcode resources.",
        subcommands: [
            XCTemplateCommand.self,
            XCSnippetCommand.self
        ]
    )
}
