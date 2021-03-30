
import XCTemplate
import XCTest
import class Foundation.Bundle

final class XCCountTemplatesCommandTests: XCTestCase {

    var command: CountTemplatesCommand!
    var folder: DynamicXCTemplateFolder!

    override func setUp() {
        folder = DynamicXCTemplateFolder(
            url: FileManager.default.url(for: .workingDirectory),
            fileManager: .default
        )
        command = CountTemplatesCommand(
            url: folder.rootUrl,
            fileManager: .default
        )
    }

    override func tearDown() {
        folder.clean()
    }

    func testThreeBasicTemplatesExample() throws {
        folder.prepare(model: .threeBasicTemplates)
        let count = XT_XCTAssertNoThrow { try self.command.countTemplates() }
        XCTAssertEqual(count, 3)
    }

    func testTemplateHierarchyExample() throws {
        folder.prepare(model: .templateHierarchy)
        let count = XT_XCTAssertNoThrow { try self.command.countTemplates() }
        XCTAssertEqual(count, 4)
    }

    static var allTests = [
        ("testThreeBasicTemplatesExample", testThreeBasicTemplatesExample),
    ]
}

func XT_XCTAssertNoThrow<T>(block: () throws -> T) -> T {
    do {
        return try block()
    } catch {
        XCTFail(error.localizedDescription)
        fatalError()
    }
}
