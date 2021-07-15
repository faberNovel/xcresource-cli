
import Foundation

protocol XCTemplateFolderDownloadingStrategy {
    func download(to destination: URL) throws
}
