
import Foundation

protocol XCTemplateFolderURLProviding {
    func rootTemplateURL() -> URL
    func url(for namespace: XCTemplateNamespace) -> URL
}

class NamespaceFolderURLProvider: XCTemplateFolderURLProviding {

    func rootTemplateURL() -> URL {
        URL(fileURLWithPath: "Library/Developer/Xcode/Templates")
    }

    func url(for namespace: XCTemplateNamespace) -> URL {
        rootTemplateURL().appendingPathComponent(namespace.id)
    }
}
