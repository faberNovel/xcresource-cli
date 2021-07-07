
import Foundation
import ArgumentParser
import XCTemplate

struct ListSnippetsCommand: ParsableCommand {

    @Option(
        name: .shortAndLong,
        help: "The snippet namespace to list. All namespaces are listed if not specified."
    )
    var namespace: String?

    public static let configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List Xcode snippet."
    )

    // MARK: - ParsableCommand

    func run() throws {
        // TODO:(gz)
    }
}
