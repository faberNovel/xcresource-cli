
import Foundation
import ArgumentParser
import XCResource

struct OpenSnippetsCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(
        commandName: "open",
        abstract: "Open Xcode snippets folder."
    )

    // MARK: - ParsableCommand

    func run() throws {
        try XCSnippetCLI().openSnippetFolder()
    }
}
