
import Foundation

struct XCSnippetFile {

    struct Tag: Hashable {

        let identifier: String

        static let unspecified = Tag(identifier: UUID().uuidString)
        static func custom(_ id: String) -> Tag {
            Tag(identifier: id)
        }
    }

    let identifier: String
    let name: String
    let tag: Tag
}
