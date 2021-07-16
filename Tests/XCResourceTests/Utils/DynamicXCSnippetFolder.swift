
import XCResource
import Foundation

class DynamicXCSnippetFolder {

    struct Snippet {

        let id: String
        fileprivate let content: String
    }

    let rootUrl: URL
    private let fileManager: FileManager

    init(url: URL, fileManager: FileManager) {
        self.rootUrl = url
        self.fileManager = fileManager
    }

    func clean() {
        try? fileManager.removeItem(at: rootUrl)
    }

    func generate() {
        fileManager.createDirectoryIfNeeded(at: rootUrl)
    }

    func create(_ snippet: Snippet) {
        fileManager.createDirectoryIfNeeded(at: rootUrl)
        let url = rootUrl.appendingPathComponent(snippet.id).appendingPathExtension("codesnippet")
        try! snippet.content.data(using: .utf8)!.write(to: url)
    }

    @discardableResult
    func createRandomFile() -> String {
        fileManager.createDirectoryIfNeeded(at: rootUrl)
        let name = UUID().uuidString
        try! "Random file".data(using: .utf8)!.write(to: rootUrl.appendingPathComponent(name))
        return name
    }

    func snippet(named name: String) -> DynamicXCSnippetFolder.Snippet? {
        let url = rootUrl.appendingPathComponent(name).appendingPathExtension("codesnippet")
        guard let data = try? Data(contentsOf: url),
              let content = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return DynamicXCSnippetFolder.Snippet(
            id: url.deletingLastPathComponent().lastPathComponent,
            content: content
        )
    }

    func create(_ snippets: [Snippet]) {
        snippets.forEach { create($0) }
    }

    func onlyContains(_ snippets: Snippet...) -> Bool {
        let names = snippets.map { $0.id }
        let filenames = names.map { "\($0).codesnippet" }
        guard fileManager.directoryOnlyContains(filenames, at: rootUrl) else { return false }
        for snippet in snippets {
            guard let local = self.snippet(named: snippet.id), local == snippet else {
                return false
            }
        }
        return true
    }
}

extension DynamicXCSnippetFolder.Snippet {

    static func basic(id: String) -> DynamicXCSnippetFolder.Snippet {
        .init(
            id: id,
            content:
                """
                <?xml version="1.0" encoding="UTF-8"?>
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                    <key>IDECodeSnippetCompletionPrefix</key>
                    <string>COMPLETION-PREFIX</string>
                    <key>IDECodeSnippetCompletionScopes</key>
                    <array>
                        <string>All</string>
                    </array>
                    <key>IDECodeSnippetContents</key>
                    <string>Content</string>
                    <key>IDECodeSnippetIdentifier</key>
                    <string>\(id)</string>
                    <key>IDECodeSnippetLanguage</key>
                    <string>Xcode.SourceCodeLanguage.Generic</string>
                    <key>IDECodeSnippetSummary</key>
                    <string></string>
                    <key>IDECodeSnippetTitle</key>
                    <string>TITLE</string>
                    <key>IDECodeSnippetUserSnippet</key>
                    <true/>
                    <key>IDECodeSnippetVersion</key>
                    <integer>2</integer>
                </dict>
                </plist>
                """
        )
    }

    static func tagged(id: String, tag: String) -> DynamicXCSnippetFolder.Snippet {
        .init(
            id: id,
            content:
                """
                <?xml version="1.0" encoding="UTF-8"?>
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                    <key>IDECodeSnippetCompletionPrefix</key>
                    <string>COMPLETION-PREFIX</string>
                    <key>IDECodeSnippetCompletionScopes</key>
                    <array>
                        <string>All</string>
                    </array>
                    <key>IDECodeSnippetContents</key>
                    <string>Content</string>
                    <key>IDECodeSnippetIdentifier</key>
                    <string>\(id)</string>
                    <key>IDECodeSnippetLanguage</key>
                    <string>Xcode.SourceCodeLanguage.Generic</string>
                    <key>IDECodeSnippetSummary</key>
                    <string>Namespace: \(tag)</string>
                    <key>IDECodeSnippetTitle</key>
                    <string>TITLE</string>
                    <key>IDECodeSnippetUserSnippet</key>
                    <true/>
                    <key>IDECodeSnippetVersion</key>
                    <integer>2</integer>
                </dict>
                </plist>
                """
        )
    }
}

extension DynamicXCSnippetFolder.Snippet: Equatable {

    // MARK: - Equatable

    static func == (lhs: DynamicXCSnippetFolder.Snippet, rhs: DynamicXCSnippetFolder.Snippet) -> Bool {
        do {
            let lhsData = lhs.content.data(using: .utf8) ?? Data()
            let rhsData = rhs.content.data(using: .utf8) ?? Data()
            let lhsDecodedData = try PropertyListSerialization.format(lhsData)
            let rhsDecodedData = try PropertyListSerialization.format(rhsData)
            let lhsFormattedString = String(data: lhsDecodedData, encoding: .utf8) ?? ""
            let rhsFormattedString = String(data: rhsDecodedData, encoding: .utf8) ?? ""
            return lhsFormattedString == rhsFormattedString
        } catch {
            return true
        }
    }
}

private extension PropertyListSerialization {

    static func format(_ data: Data) throws -> Data {
        try PropertyListSerialization.data(
            fromPropertyList: try PropertyListSerialization.propertyList(
                from: data,
                format: nil
            ),
            format: .xml,
            options: .zero
        )
    }
}
