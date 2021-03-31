
import Foundation
import ArgumentParser
import XCTemplate

struct RemoveTemplatesCommand: ParsableCommand {

    @Option(
        name: .shortAndLong,
        help: "The template namespace to delete."
    )
    var namespace: String = "FABERNOVEL"

    public static let configuration = CommandConfiguration(
        commandName: "remove",
        abstract: "Remove Xcode templates."
    )

    private var fileManager: FileManager { .default }

    // MARK: - ParsableCommand

    func run() throws {
        try XCTemplateCLI().removeTemplates(for: XCTemplateNamespace(namespace))
    }
}
