
import Foundation
import ArgumentParser

struct XCSnippetCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "xcsnippet",
        abstract: "A Swift command-line tool to manage Xcode snippet.",
        subcommands: [
            InstallSnippetsCommand.self,
            RemoveSnippetsCommand.self,
            ListSnippetsCommand.self,
            OpenSnippetsCommand.self
        ]
    )
}
