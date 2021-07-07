
import Foundation
import ArgumentParser

struct XCUtilsCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "xcutils",
        abstract: "A Swift command-line tool to manage Xcode resources.",
        subcommands: [
            XCTemplateCommand.self,
            XCSnippetCommand.self
        ]
    )
}
