
import Foundation

struct SnippetFileTagToSnippetNamespaceMapper {

    func map(_ tag: XCSnippetFile.Tag) -> XCSnippetNamespace {
        if tag == .unspecified {
            return .xcodeDefault
        }
        return XCSnippetNamespace(tag.identifier)
    }
}

struct SnippetNamespaceToSnippetFileTagMapper {

    func map(_ namespace: XCSnippetNamespace) throws -> XCSnippetFile.Tag {
        switch namespace.kind {
        case .xcodeDefault:
            return .unspecified
        case let .custom(id):
            return XCSnippetFile.Tag(identifier: id)
        }
    }
}
