import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(XCTemplateFileManagerTests.allTests),
        testCase(XCTemplateDownloaderTests.allTests),
    ]
}
#endif
