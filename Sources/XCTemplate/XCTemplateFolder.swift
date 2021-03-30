
import Foundation

public struct XCTemplateFolder {

    public let name: String
    public let folders: [XCTemplateFolder]
    public let templates: [XCTemplate]

    public init(name: String,
                folders: [XCTemplateFolder],
                templates: [XCTemplate]) {
        self.name = name
        self.folders = folders
        self.templates = templates
    }

    func templateCount() -> Int {
        templates.count + folders.reduce(into: 0, { $0 += $1.templateCount() })
    }
}
