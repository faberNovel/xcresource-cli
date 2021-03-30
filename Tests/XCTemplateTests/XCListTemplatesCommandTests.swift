
import Foundation
import XCTemplate
import XCTest

class TestOutput: CommandOutput {

    var result = ""

    func print(_ items: Any...) {
        if !result.isEmpty {
            result += "\n"
        }
        result += items.compactMap { $0 as? String }.joined(separator: " ")
    }
}

final class XCListTemplatesCommandTests: XCTestCase {

    var output: TestOutput!
    var command: ListTemplatesCommand!
    var folder: DynamicXCTemplateFolder!

    override func setUp() {
        output = TestOutput()
        folder = DynamicXCTemplateFolder(
            url: FileManager.default.url(for: .workingDirectory),
            fileManager: .default
        )
        command = ListTemplatesCommand(
            namespace: nil,
            fileManager: .default,
            output: output,
            urlProviding: FileManager.default
        )
    }

    override func tearDown() {
        folder.clean()
    }

    func testEmptyTemplate() throws {
        let result = """
        # GeneratedTemplates
        No template installed
        """
        expect(.empty, toMatch: result)
    }

    func testListThreeBasicTemplates() throws {
        let result = """
        # GeneratedTemplates
        ~> Template2.xctemplate
        ~> Template3.xctemplate
        ~> Template1.xctemplate
        """
        expect(.threeBasicTemplates, toMatch: result)
    }

    func testListTemplateHierarchy() throws {
        let result = """
        # GeneratedTemplates
        ~> Template2.xctemplate
        ## Template
        ~> Template3.xctemplate
        ~> Template4.xctemplate
        ~> Template1.xctemplate
        """
        expect(.templateHierarchy, toMatch: result)
    }

    private func expect(_ model: XCTemplateModel, toMatch content: String) {
        folder.prepare(model: model)
        XCTAssertNoThrow(try command.run())
        XCTAssertEqual(content, output.result)
    }

    static var allTests = [
        ("testListThreeBasicTemplates", testListThreeBasicTemplates),
        ("testListTemplateHierarchy", testListTemplateHierarchy),
    ]
}
