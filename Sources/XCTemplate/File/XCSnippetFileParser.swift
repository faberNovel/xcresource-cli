
import Foundation

class XCSnippetFileParser {

    private enum Constants {
        static let tagKey = "IDECodeSnippetSummary"
    }

    private let tagger = XCSnippetFileSummaryTagger()

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
        guard let content = snippetContent[Constants.tagKey] as? String else {
            return
        }
        snippetContent[Constants.tagKey] = tagger.tag(content, tag: tag.identifier)
    }

    func tag() throws -> XCSnippetFile.Tag {
        guard let content = snippetContent[Constants.tagKey] as? String else {
            return .unspecified
        }
        return tagger.tag(in: content).flatMap { XCSnippetFile.Tag(identifier: $0) } ?? .unspecified
    }
}
