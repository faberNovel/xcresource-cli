
import Foundation

protocol XCTemplateFolderURLProviding {
    func rootTemplateURL() -> URL
    func url(for namespace: XCTemplateNamespace) -> URL
}

class NamespaceFolderURLProvider: XCTemplateFolderURLProviding {

    func rootTemplateURL() -> URL {
        fatalError()
    }

    func url(for namespace: XCTemplateNamespace) -> URL {
        fatalError()
    }
}
