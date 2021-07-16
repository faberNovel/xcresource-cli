
@testable import XCResource
import XCTest

private struct TagContentSample {
    let initialContent: String
    let initialTag: String?
    let tag: String
    let expectedContent: String
}

final class XCSnippetFileSummaryTaggerTests: XCTestCase {

    func testTagging() {
        let tagger = XCSnippetFileSummaryTagger()
        let samples = [
            TagContentSample(
                initialContent: "",
                initialTag: nil,
                tag: "A",
                expectedContent: "Namespace: A"
            ),
            TagContentSample(
                initialContent: "CONTENT",
                initialTag: nil,
                tag: "A",
                expectedContent: "CONTENT\n\nNamespace: A"
            ),
            TagContentSample(
                initialContent: "CONTENT Namespace: A",
                initialTag: "A",
                tag: "B",
                expectedContent: "CONTENT\n\nNamespace: B"
            ),
            TagContentSample(
                initialContent: "Namespace: A CONTENT\nNamespace: B\nNamespace: C",
                initialTag: "A",
                tag: "B",
                expectedContent: "CONTENT\n\nNamespace: B"
            ),
            TagContentSample(
                initialContent: "Namespace: A CONTENT\nNamespace: B\nNamespace: C END",
                initialTag: "A",
                tag: "B",
                expectedContent: "CONTENT\nEND\n\nNamespace: B"
            ),
            TagContentSample(
                initialContent: "CONTENT\n",
                initialTag: nil,
                tag: "B",
                expectedContent: "CONTENT\n\nNamespace: B"
            ),
            TagContentSample(
                initialContent: "CONTENT\n\n",
                initialTag: nil,
                tag: "B",
                expectedContent: "CONTENT\n\nNamespace: B"
            ),
        ]
        samples.enumerated().forEach { i, sample in
            XCTAssertEqual(tagger.tag(in: sample.initialContent), sample.initialTag)
            XCTAssertEqual(
                tagger.tag(sample.initialContent, tag: sample.tag),
                sample.expectedContent
            )
            XCTAssertEqual(tagger.tag(in: sample.expectedContent), sample.tag)
        }
    }
}
