
import Foundation
import ArgumentParser
import XCResource

struct RemoveSnippetsCommand: ParsableCommand {

    @Option(
        name: .shortAndLong,
        help: "The snippet namespace to delete. All the snippets are deleted if not specified."
    )
    var namespace: String?

    public static let configuration = CommandConfiguration(
        commandName: "remove",
        abstract: "Remove Xcode snippet."
    )

    // MARK: - ParsableCommand

    func run() throws {
        let cli = XCSnippetCLI()
        if let namespace = namespace {
            let xcnamespace = XCSnippetNamespace(namespace)
            try cli.removeSnippets(for: xcnamespace)
        } else {
            let namespaces = try cli.snippetNamespaces()
            try namespaces.forEach { namespace in
                try cli.removeSnippets(for:namespace)
            }
        }
    }
}
