
import Foundation

struct SnippetFileToSnippetMapper {

    func map(_ file: XCSnippetFile) -> XCSnippet {
        XCSnippet(identifier: file.identifier, name: file.name)
    }
}
