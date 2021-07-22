
import Foundation

public class XCSnippetCLI {

    private let library = XCSnippetLibrary()

    // MARK: - Life Cycle

    public init() {}

    // MARK: - Public

    public func installSnippets(url: String,
                                pointer: String,
                                namespace: String,
                                snippetsPath: String) throws -> XCSnippetList {
        let url = try URLInputParser().absoluteURL(fromInput: url)
        let namespace = XCSnippetNamespace(namespace)
        try library.installSnippets(
            for: namespace,
            from: .git(
                url: url,
                reference: GitReference(pointer),
                folderPath: snippetsPath
            )
        )
        return try library.snippetList(for: namespace)
    }

    public func removeSnippets(namespace: String?) throws {
        if let namespace = namespace {
            let xcnamespace = XCSnippetNamespace(namespace)
            try library.removeSnippets(for: xcnamespace)
        } else {
            let namespaces = try library.snippetNamespaces()
            try namespaces.forEach { namespace in
                try library.removeSnippets(for:namespace)
            }
        }
    }

    public func snippetList(namespace: String?) throws -> [XCSnippetNamespace: XCSnippetList] {
        if let namespace = namespace {
            let xcnamespace = XCSnippetNamespace(namespace)
            return [xcnamespace: try library.snippetList(for: xcnamespace)]
        } else {
            let namespaces = try library.snippetNamespaces()
            return Dictionary(uniqueKeysWithValues: try namespaces.map {
                ($0, try library.snippetList(for: $0))
            })
        }
    }

    public func openSnippetFolder() throws {
        try Shell().execute(.open(path: library.snippetFolderURL().path))
    }
}
