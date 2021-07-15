
import Foundation
import ArgumentParser

struct XCSnippetCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "snippet",
        abstract: "A command to manage Xcode snippets.",
        subcommands: [
            InstallSnippetsCommand.self,
            RemoveSnippetsCommand.self,
            ListSnippetsCommand.self,
            OpenSnippetsCommand.self
        ]
    )
}
