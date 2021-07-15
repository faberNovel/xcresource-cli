
import Foundation
import ArgumentParser

struct XCSnippetCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "snippet",
        subcommands: [
            InstallSnippetsCommand.self,
            RemoveSnippetsCommand.self,
            ListSnippetsCommand.self,
            OpenSnippetsCommand.self
        ]
    )
}
