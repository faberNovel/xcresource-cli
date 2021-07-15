
import Foundation

public enum XCSnippetSource {
    case git(url: URL, reference: GitReference, folderPath: String)
}
