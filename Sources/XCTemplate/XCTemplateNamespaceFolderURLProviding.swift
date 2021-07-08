
import Foundation

protocol XCTemplateFolderURLProviding {
    func rootTemplateURL() -> URL
    func url(for namespace: XCTemplateNamespace) -> URL
}

class NativeNamespaceFolderURLProvider: XCTemplateFolderURLProviding,
                                        XCSnippetFolderURLProviding {

    // MARK: - XCTemplateFolderURLProviding

    func rootTemplateURL() -> URL {
        URL(
            fileURLWithPath: "Library/Developer/Xcode/Templates",
            relativeTo: FileManager.default.homeDirectoryForCurrentUser
        )
    }

    func url(for namespace: XCTemplateNamespace) -> URL {
        rootTemplateURL().appendingPathComponent(namespace.id)
    }

    // MARK: - XCSnippetFolderURLProviding

    func rootSnippetFolderURL() -> URL {
        URL(
            fileURLWithPath: "Library/Developer/Xcode/UserData/CodeSnippets",
            relativeTo: FileManager.default.homeDirectoryForCurrentUser
        )
    }
}
