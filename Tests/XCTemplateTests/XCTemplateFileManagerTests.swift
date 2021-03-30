
@testable import XCTemplate
import XCTest

final class XCTemplateFileManagerTests: XCTestCase {

    var urlProvider: TestXCTemplateFolderURLProvider!
    var manager: XCTemplateFileManager!
    var folder: DynamicXCTemplateFolder!

    override func setUp() {
        urlProvider = TestXCTemplateFolderURLProvider()
        folder = DynamicXCTemplateFolder(
            url: urlProvider.root,
            fileManager: .default
        )
        manager = XCTemplateFileManager(fileManager: .default)
    }

    override func tearDown() {
        folder.clean()
    }

    func testThreeBasicTemplatesExample() throws {
        folder.prepare(model: .threeBasicTemplates)
        let result = try manager.templateFolder(at: folder.rootUrl)
        XCTAssertEqual(result.templateCount(), 3)
    }

    func testTemplateHierarchyExample() throws {
        folder.prepare(model: .templateHierarchy)
        let result = try manager.templateFolder(at: folder.rootUrl)
        XCTAssertEqual(result.templateCount(), 4)
    }

    static var allTests = [
        ("testThreeBasicTemplatesExample", testThreeBasicTemplatesExample),
        ("testTemplateHierarchyExample", testTemplateHierarchyExample),
    ]
}
