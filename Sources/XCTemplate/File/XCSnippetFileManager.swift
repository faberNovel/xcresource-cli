
import Foundation

class XCSnippetFileManager {

    private let fileManager: FileManager
    private let coder = XCSnippetCoder()

    // MARK: - Life Cycle

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    // MARK: - Public

    func snippets(at url: URL) throws -> [XCSnippetFile] {
        try enumerateSnippets(at: url).map { $1 }
    }

    func snippets(at url: URL, with tag: XCSnippetFile.Tag) throws -> [XCSnippetFile] {
        try snippets(at: url).filter { $0.tag == tag }
    }

    func snippetTags(at url: URL) throws -> Set<XCSnippetFile.Tag> {
        Set(try enumerateSnippets(at: url).map { $1.tag })
    }

    func removeSnippets(with tag: XCSnippetFile.Tag, at url: URL) throws {
        try enumerateSnippets(at: url)
            .filter { $1.tag == tag }
            .forEach { url, _ in
                try fileManager.removeItem(at: url)
            }
    }

    func tagSnippets(at url: URL, tag: XCSnippetFile.Tag) throws {
        try enumerateSnippets(at: url).forEach { url, _ in
            let data = try Data(contentsOf: url)
            let parser = try XCSnippetFileParser(data: data)
            try parser.tag(tag)
            try coder.encodeSnippet(parser.snippetContent).write(to: url)
        }
    }

    func copySnippets(at origin: URL,
                      to destination: URL) throws {
        try enumerateSnippets(at: origin).forEach { url, _ in
            try fileManager.copyItem(
                at: url,
                to: destination.appendingPathComponent(url.lastPathComponent)
            )
        }
    }

    // MARK: - Private

    private func enumerateSnippets(at url: URL) throws -> [(URL, XCSnippetFile)] {
        try fileManager.contentsOfDirectory(at: url).compactMap { url -> (URL, XCSnippetFile)? in
            guard url.isSnippet else { return nil }
            let data = try Data(contentsOf: url)
            let parser = try XCSnippetFileParser(data: data)
            return (url, XCSnippetFile(
                identifier: url.deletingPathExtension().lastPathComponent,
                tag: try parser.tag()
            ))
        }
    }
}

class XCSnippetCoder {

    enum CodingError: Error {
        case invalidData
    }

    func decodeSnippet(from data: Data) throws -> [String: Any] {
        guard let file = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            throw CodingError.invalidData
        }
        return file
    }

    func encodeSnippet(_ snippet: [String: Any]) throws -> Data {
        try PropertyListSerialization.data(fromPropertyList: snippet, format: .xml, options: .zero)
    }
}

class XCSnippetFileParser {

    private enum Constants {
        static let tagKey = "XCUTILS-TAG"
    }

    enum ParsingError: Error {
        case invalidData
    }

    private(set) var snippetContent: [String: Any]

    init(data: Data) throws {
        snippetContent = try XCSnippetCoder().decodeSnippet(from: data)
    }

    init(snippetContent: [String: Any]) {
        self.snippetContent = snippetContent
    }

    func tag(_ tag: XCSnippetFile.Tag) throws {
        snippetContent[Constants.tagKey] = tag == .unspecified ? nil : tag.identifier
    }

    func tag() throws -> XCSnippetFile.Tag {
        (snippetContent[Constants.tagKey] as? String).flatMap { XCSnippetFile.Tag(identifier: $0) } ?? .unspecified
    }
}
