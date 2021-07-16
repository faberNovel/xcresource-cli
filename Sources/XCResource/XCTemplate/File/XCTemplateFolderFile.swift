
import Foundation

struct XCTemplateFolderFile: Equatable {
    let name: String
    let url: URL
    let templates: [XCTemplateFile]
    let folders: [XCTemplateFolderFile]

    func templateCount() -> Int {
        templates.count + folders.reduce(into: 0, { $0 += $1.templateCount() })
    }

    func isEmpty() -> Bool {
        templateCount() == 0
    }
}
