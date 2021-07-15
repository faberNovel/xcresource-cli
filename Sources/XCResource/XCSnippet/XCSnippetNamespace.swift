
import Foundation

public struct XCSnippetNamespace: Hashable {

    enum Kind: Hashable {
        case custom(String)
        case xcodeDefault
    }

    let kind: Kind

    public init(_ id: String) {
        self.init(.custom(id))
    }

    init(_ kind: Kind) {
        self.kind = kind
    }
}

public extension XCSnippetNamespace {

    static var xcodeDefault: XCSnippetNamespace {
        XCSnippetNamespace(.xcodeDefault)
    }

    var name: String {
        switch kind {
        case let .custom(name):
            return name
        case .xcodeDefault:
            return "Xcode default"
        }
    }
}
