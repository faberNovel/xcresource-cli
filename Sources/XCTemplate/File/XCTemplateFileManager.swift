
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

    func templateFolder(at url: URL) throws -> XCTemplateFolderFile {
        try recursiveTemplateFolder(at: url)
    }

    private func recursiveTemplateFolder(at url: URL) throws -> XCTemplateFolderFile {
        let urls = try fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: .skipsHiddenFiles
        )
        var templates: [XCTemplateFile] = []
        var folders: [XCTemplateFolderFile] = []
        try urls.forEach { url in
            if url.isTemplate {
                print("Template \(url)")
                templates.append(XCTemplateFile(name: url.lastPathComponent, url: url))
            } else if url.isDirectory {
                folders.append(try recursiveTemplateFolder(at: url))
            }
        }
        print("Folder \(url)")
        return XCTemplateFolderFile(
            name: url.lastPathComponent,
            url: url,
            templates: templates,
            folders: folders
        )
    }
}
