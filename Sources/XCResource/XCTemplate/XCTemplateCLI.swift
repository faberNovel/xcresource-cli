
import Foundation

public class XCTemplateCLI {

    private let templateLibrary: XCTemplateLibrary

    // MARK: - Life Cycle

    public init() {
        self.templateLibrary = XCTemplateLibrary()
    }

    // MARK: - Public

    public func downloadTemplates(url: String,
                                  pointer: String,
                                  namespace: String,
                                  templatesPath: String) throws -> XCTemplateFolder {
        let url = try URLInputParser().absoluteURL(fromInput: url)
        let templateNamespace = XCTemplateNamespace(namespace)
        try templateLibrary.downloadTemplates(
            for: templateNamespace,
            from: .git(
                url: url,
                reference: GitReference(pointer),
                folderPath: templatesPath
            )
        )
        return try templateLibrary.templateFolder(for: templateNamespace)
    }

    public func removeTemplates(namespace: String) throws {
        try templateLibrary.removeTemplates(for: XCTemplateNamespace(namespace))
    }

    public func templateFolder(namespace: String?) throws -> XCTemplateFolder {
        let folder: XCTemplateFolder
        if let namespace = namespace {
            folder = try templateLibrary.templateFolder(for: XCTemplateNamespace(namespace))
        } else {
            folder = try templateLibrary.rootTemplateFolder()
        }
        return folder
    }

    public func openRootTemplateFolder() throws {
        try Shell().execute(.open(path: templateLibrary.rootTemplateFolderURL().path))
    }
}
