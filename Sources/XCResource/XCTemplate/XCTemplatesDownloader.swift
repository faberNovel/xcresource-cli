
import Foundation

class XCTemplatesDownloader {

    let factory: XCTemplateFolderDownloadingStrategyFactory

    // MARK: - Life Cycle

    init(factory: XCTemplateFolderDownloadingStrategyFactory) {
        self.factory = factory
    }

    // MARK: - Public

    func downloadTemplates(at destination: URL, from source: XCTemplateSource) throws {
        try factory.makeStrategy(source: source).download(to: destination)
    }
}
