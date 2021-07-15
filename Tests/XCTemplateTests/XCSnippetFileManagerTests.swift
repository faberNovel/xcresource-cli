
@testable import XCTemplate
import XCTest

final class XCSnippetFileManagerTests: XCTestCase {

    var workingDirectoryURL: URL!
    var fileManager: FileManager!
    var manager: XCSnippetFileManager!
    var folder: DynamicXCSnippetFolder!

    override func setUp() {
        workingDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent("XCSnippetFileManagerTests")
        fileManager = .default
        folder = DynamicXCSnippetFolder(
            url: workingDirectoryURL,
            fileManager: fileManager
        )
        folder.clean()
        manager = XCSnippetFileManager(fileManager: .default)
    }

    override func tearDown() {
        folder.clean()
    }

    func testListSnippets() throws {
        folder.create(.basic(id: "A"))
        folder.create(.basic(id: "B"))
        folder.createRandomFile()
        let results = try manager.snippets(at: folder.rootUrl)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].identifier, "A")
        XCTAssertEqual(results[1].identifier, "B")
    }

    func testListTaggedSnippets() throws {
        folder.create(.basic(id: "A"))
        folder.create(.basic(id: "B"))
        folder.create(.tagged(id: "T1A", tag: "T1"))
        folder.create(.tagged(id: "T1B", tag: "T1"))
        folder.create(.tagged(id: "T2A", tag: "T2"))
        folder.create(.tagged(id: "T2B", tag: "T2"))
        folder.createRandomFile()
        let unspecifiedResults = try manager.snippets(at: folder.rootUrl, with: .unspecified)
        XCTAssertEqual(unspecifiedResults.count, 2)
        XCTAssertEqual(unspecifiedResults[0].identifier, "A")
        XCTAssertEqual(unspecifiedResults[1].identifier, "B")
        let tagOneResults = try manager.snippets(at: folder.rootUrl, with: .custom("T1"))
        XCTAssertEqual(tagOneResults.count, 2)
        if tagOneResults.count == 2 {
            XCTAssertEqual(tagOneResults[0].identifier, "T1A")
            XCTAssertEqual(tagOneResults[1].identifier, "T1B")
        }
        let tagTwoResults = try manager.snippets(at: folder.rootUrl, with: .custom("T2"))
        XCTAssertEqual(tagTwoResults.count, 2)
        if tagTwoResults.count == 2 {
            XCTAssertEqual(tagTwoResults[0].identifier, "T2A")
            XCTAssertEqual(tagTwoResults[1].identifier, "T2B")
        }
    }

    func testListSnippetTags() throws {
        folder.create(.tagged(id: "A", tag: "A"))
        folder.create(.tagged(id: "B", tag: "B"))
        folder.create(.tagged(id: "C", tag: "C"))
        folder.create(.basic(id: "D"))
        let tags = try manager.snippetTags(at: folder.rootUrl).sorted(by: { $0.identifier < $1.identifier })
        XCTAssertEqual(tags.count, 4)
        XCTAssertTrue(tags.contains(XCSnippetFile.Tag(identifier: "A")))
        XCTAssertTrue(tags.contains(XCSnippetFile.Tag(identifier: "B")))
        XCTAssertTrue(tags.contains(XCSnippetFile.Tag(identifier: "C")))
        XCTAssertTrue(tags.contains(XCSnippetFile.Tag.unspecified))
    }

    func testTagSnippets() throws {
        folder.create(.tagged(id: "A", tag: "A"))
        folder.create(.basic(id: "B"))
        let random = folder.createRandomFile()
        let tagB = XCSnippetFile.Tag(identifier: "B")
        try manager.tagSnippets(at: folder.rootUrl, tag: tagB)
        try fileManager.assertDirectoryContains(
            ["A.codesnippet", "B.codesnippet", random],
            at: folder.rootUrl
        )
        if let a = folder.snippet(named: "A.codesnippet") {
            XCTAssertEqual(a, .tagged(id: "A", tag: "B"))
        }
        if let b = folder.snippet(named: "B.codesnippet") {
            XCTAssertEqual(b, .tagged(id: "B", tag: "B"))
        }
    }

    func testSnippetRemoval() throws {
        folder.create(.tagged(id: "A", tag: "A"))
        folder.create(.basic(id: "B"))
        let random = folder.createRandomFile()
        try fileManager.assertDirectoryContains(
            ["A.codesnippet", "B.codesnippet", random],
            at: folder.rootUrl
        )
        try manager.removeSnippets(with: .unspecified, at: folder.rootUrl)
        try fileManager.assertDirectoryContains(
            ["A.codesnippet", random],
            at: folder.rootUrl
        )
        try manager.removeSnippets(with: XCSnippetFile.Tag(identifier: "A"), at: folder.rootUrl)
        try fileManager.assertDirectoryContains(
            [random],
            at: folder.rootUrl
        )
    }

    func testCopying() throws {
        folder.create(.basic(id: "A"))
        folder.create(.basic(id: "B"))
        let destination = DynamicXCSnippetFolder(
            url: folder.rootUrl.appendingPathComponent("Dst"),
            fileManager: fileManager
        )
        destination.generate()
        try manager.copySnippets(at: folder.rootUrl, to: destination.rootUrl)
        try fileManager.assertDirectoryContains(
            ["A.codesnippet", "B.codesnippet"],
            at: destination.rootUrl
        )
        if let a = destination.snippet(named: "A.codesnippet") {
            XCTAssertEqual(a, .basic(id: "A"))
        }
        if let b = destination.snippet(named: "B.codesnippet") {
            XCTAssertEqual(b, .basic(id: "B"))
        }
    }
}
