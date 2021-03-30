
import Foundation

enum XCTemplateSource {
    case git(url: URL, reference: GitReference, folderPath: String)
}
