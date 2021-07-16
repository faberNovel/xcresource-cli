
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
        if let namespace = namespace {
            let xcnamespace = XCSnippetNamespace(namespace)
            try cli.describe(xcnamespace)
        } else {
            let namespaces = try cli.snippetNamespaces()
            try namespaces.forEach { namespace in
                try cli.describe(namespace)
            }
        }
    }
}

private extension XCSnippetCLI {

    func describe(_ namespace: XCSnippetNamespace) throws {
        print("#", namespace.name)
        try snippetList(for: namespace).snippets.forEach { snippet in
            print("-", snippet.name)
        }
    }
}
