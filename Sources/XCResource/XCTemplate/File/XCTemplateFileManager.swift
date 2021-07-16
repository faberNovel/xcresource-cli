
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

    func copy(_ folder: XCTemplateFolderFile, to destination: URL) throws {
        try folder.templates.forEach { template in
            try fileManager.copyItem(
                at: template.url,
                to: destination.appendingPathComponent(template.name)
            )
        }
        try folder.folders.forEach { folder in
            let url = destination.appendingPathComponent(folder.name)
            try fileManager.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
            try copy(folder, to: url)
        }
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
                templates.append(XCTemplateFile(name: url.lastPathComponent, url: url))
            } else if url.isDirectory {
                folders.append(try recursiveTemplateFolder(at: url))
            }
        }
        return XCTemplateFolderFile(
            name: url.lastPathComponent,
            url: url,
            templates: templates,
            folders: folders
        )
    }
}
