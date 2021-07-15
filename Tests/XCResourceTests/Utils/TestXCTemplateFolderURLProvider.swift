
@testable import XCResource
import Foundation

class TestXCTemplateFolderURLProvider: XCTemplateFolderURLProviding {

    let root: URL

    init() {
        root = try! FileManager.default.createTemporarySubdirectory()
    }

    func rootTemplateURL() -> URL {
        root
    }

    func url(for namespace: XCTemplateNamespace) -> URL {
        root.appendingPathComponent(namespace.id)
    }
}
