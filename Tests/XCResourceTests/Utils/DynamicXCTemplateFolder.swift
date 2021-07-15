
import XCResource
import Foundation

class DynamicXCTemplateFolder {

    let rootUrl: URL
    private let fileManager: FileManager

    init(url: URL, fileManager: FileManager) {
        self.rootUrl = url
        self.fileManager = fileManager
        fileManager.createDirectoryIfNeeded(at: rootUrl)
    }

    func clean() {
        try? fileManager.removeItem(at: rootUrl)
    }

    func createFolder(named name: String) -> DynamicXCTemplateFolder {
        let url = rootUrl.appendingPathComponent(name)
        return DynamicXCTemplateFolder(url: url, fileManager: fileManager)
    }

    func createTemplate(named name: String) {
        generateRootTemplate(name: name)
    }

    // MARK: - Private

    private func generateRootTemplate(name: String) {
        generateTemplate(name: name, at: rootUrl)
    }

    private func generateTemplate(name: String, at url: URL) {
        let target = url.appendingPathComponent(name).appendingPathExtension("xctemplate")
        fileManager.createFile(atPath: target.path, contents: nil, attributes: nil)
    }
}
