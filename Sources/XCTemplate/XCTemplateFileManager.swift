
import Foundation

class XCTemplateFileManager {

    private let fileManager: FileManager

    // MARK: - Life Cycle

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    // MARK: - Public

    func removeTemplateFolder(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }

    func templateFolder(at url: URL) throws -> XCTemplateFolder {
        try recursiveTemplateFolder(at: url)
    }

    private func recursiveTemplateFolder(at url: URL) throws -> XCTemplateFolder {
        let urls = try fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [],
            options: .skipsHiddenFiles
        )
        var templates: [XCTemplate] = []
        var folders: [XCTemplateFolder] = []
        try urls.forEach { url in
            if url.isTemplate {
                templates.append(XCTemplate(name: url.lastPathComponent))
            } else {
                folders.append(try recursiveTemplateFolder(at: url))
            }
        }
        return XCTemplateFolder(
            name: url.lastPathComponent,
            folders: folders,
            templates: templates
        )
    }
}
