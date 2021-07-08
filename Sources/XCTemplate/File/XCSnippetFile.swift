
import Foundation

struct XCSnippetFile {

    struct Tag: Hashable {

        let identifier: String

        static let unspecified = Tag(identifier: UUID().uuidString)
    }

    let identifier: String
    let tag: Tag
    let url: URL
}
