
import Foundation
import ArgumentParser
import XCResource

struct InstallSnippetsCommand: ParsableCommand {

    enum Error: Swift.Error {
        case invalidURL
    }

    @Option(
        name: .shortAndLong,
        help: "The snippet Git repository url. <url> can be a local directory path: ./src/my_template_repo."
    )
    var url: String = "https://github.com/faberNovel/CodeSnippet_iOS.git"

    @Option(
        name: .shortAndLong,
        help: "Namespaces are not visible in Xcode. A namespace acts as an installation folder. The snippets will be installed inside it. If the namespace already exists, it is replaced."
    )
    var namespace: String = "FABERNOVEL"

    @Option(
        name: .shortAndLong,
        help: "The templates subdirectory path inside the repository."
    )
    var snippetsPath: String = "XCSnippet"

    @Option(
        name: .shortAndLong,
        help: "The targeted repo pointer (branch or tag)."
    )
    var pointer: String = "master"

    public static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: "Install Xcode snippets from a git repository."
    )

    // MARK: - ParsableCommand

    func run() throws {
        guard let url = URL(string: url) else { throw Error.invalidURL }
        try XCSnippetCLI().downloadSnippets(
            for: .init(namespace),
            from: .git(
                url: url,
                reference: GitReference(pointer),
                folderPath: snippetsPath
            )
        )
    }
}
