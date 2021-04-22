
import Foundation

class XCTemplateFolderMapper {

    func map(_ file: XCTemplateFolderFile) -> XCTemplateFolder {
        XCTemplateFolder(
            name: file.name,
            folders: file.folders.map { map($0) },
            templates: file.templates.map { XCTemplate(name: $0.name) }
        )
    }
}
