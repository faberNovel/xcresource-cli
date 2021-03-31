
import Foundation

public enum XCTemplateSource {
    case git(url: URL, reference: GitReference, folderPath: String)
}
