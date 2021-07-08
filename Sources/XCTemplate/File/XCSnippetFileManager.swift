
import Foundation

class XCSnippetFileManager {

    private let fileManager: FileManager
    private let parser = XCSnippetFileParser()

    // MARK: - Life Cycle

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    // MARK: - Public

    func snippets(at url: URL) throws -> [XCSnippetFile] {
        try fileManager.contentsOfDirectory(at: url).compactMap { url -> XCSnippetFile? in
            guard url.isSnippet else { return nil }
            return XCSnippetFile(
                identifier: url.deletingPathExtension().lastPathComponent,
                tag: try parser.snippetTag(at: url) ?? .unspecified,
                url: url
            )
        }
    }

    func snippets(at url: URL, with tag: XCSnippetFile.Tag) throws -> [XCSnippetFile] {
        try snippets(at: url).filter { $0.tag == tag }
    }

    func snippetTags(at url: URL) throws -> Set<XCSnippetFile.Tag> {
        Set(try snippets(at: url).map { $0.tag })
    }

    func removeSnippets(with tag: XCSnippetFile.Tag, at url: URL) throws {
        try snippets(at: url, with: tag).forEach { snippet in
            try fileManager.removeItem(at: snippet.url)
        }
    }

    func tagSnippets(at url: URL, tag: XCSnippetFile.Tag) throws {
        try snippets(at: url).forEach { snippet in
            try parser.tagSnippet(at: snippet.url, tag: tag)
        }
    }

    func copySnippets(at origin: URL,
                      to destination: URL) throws {
        try snippets(at: origin).forEach { snippet in
            try fileManager.copyItem(
                at: snippet.url,
                to: destination.appendingPathComponent(snippet.url.lastPathComponent)
            )
        }
    }
}

class XCSnippetFileParser {

    private enum Constants {
        static let tagKey = "XCUTILS-TAG"
    }

    enum ParsingError: Error {
        case invalidData
    }

    func tagSnippet(at url: URL, tag: XCSnippetFile.Tag) throws {
        var file = try snippet(at: url)
        file[Constants.tagKey] = tag.identifier
        let result = try PropertyListSerialization.data(fromPropertyList: file, format: .xml, options: .zero)
        try result.write(to: url)
    }

    func snippetTag(at url: URL) throws -> XCSnippetFile.Tag? {
        let file = try snippet(at: url)
        return (file[Constants.tagKey] as? String).flatMap { XCSnippetFile.Tag(identifier: $0) }
    }

    // MARK: - Private

    private func snippet(at url: URL) throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        guard let file = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            throw ParsingError.invalidData
        }
        return file
    }
}
