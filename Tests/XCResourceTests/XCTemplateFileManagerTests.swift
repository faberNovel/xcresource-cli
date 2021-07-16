
@testable import XCResource
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
        folder.createTemplate(named: "Template1")
        folder.createTemplate(named: "Template2")
        folder.createTemplate(named: "Template3")
        let result = try manager.templateFolder(at: folder.rootUrl)
        XCTAssertEqual(result.templateCount(), 3)
    }

    func testTemplateHierarchyExample() throws {
        folder.createTemplate(named: "Template1")
        folder.createTemplate(named: "Template2")
        let subfolder = folder.createFolder(named: "Subfolder")
        subfolder.createTemplate(named: "Template3")
        subfolder.createTemplate(named: "Template4")
        let result = try manager.templateFolder(at: folder.rootUrl)
        XCTAssertEqual(result.templateCount(), 4)
        XCTAssertEqual(result.folders.count, 1)
        XCTAssertEqual(result.templates.count, 2)
        XCTAssertEqual(result.folders[0].templates.count, 2)
    }

    func testTemplateRemoval() throws {
        XCTAssertTrue(try manager.templateFolder(at: folder.rootUrl).folders.isEmpty)
        let sub = folder.createFolder(named: "TOREMOVE")
        XCTAssertFalse(try manager.templateFolder(at: folder.rootUrl).folders.isEmpty)
        try manager.removeTemplateFolder(at: sub.rootUrl)
        XCTAssertTrue(try manager.templateFolder(at: folder.rootUrl).folders.isEmpty)
    }

    static var allTests = [
        ("testThreeBasicTemplatesExample", testThreeBasicTemplatesExample),
        ("testTemplateHierarchyExample", testTemplateHierarchyExample),
        ("testTemplateRemoval", testTemplateRemoval)
    ]
}
