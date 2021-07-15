
import Foundation
import ArgumentParser
import XCResource

struct OpenTemplatesCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(
        commandName: "open",
        abstract: "Open Xcode templates folder."
    )

    // MARK: - ParsableCommand

    func run() throws {
        try XCTemplateCLI().openRootTemplateFolder()
    }
}
