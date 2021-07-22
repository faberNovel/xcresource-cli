
import Foundation
import ArgumentParser
import XCResource

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
        let cli = XCSnippetCLI()
        try cli.snippetList(namespace: namespace).forEach { namespace, list in
            print("#", namespace.name)
            list.snippets.forEach { snippet in
                print("-", snippet.name)
            }
        }
    }
}
