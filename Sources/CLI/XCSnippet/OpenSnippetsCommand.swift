
import Foundation
import ArgumentParser
import XCTemplate

struct OpenSnippetsCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(
        commandName: "open",
        abstract: "Open Xcode snippets folder."
    )

    // MARK: - ParsableCommand

    func run() throws {
        // TODO:(gz)
    }
}
