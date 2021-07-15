
import Foundation
import ArgumentParser
import XCResource

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

    // MARK: - ParsableCommand

    func run() throws {
        try XCTemplateCLI().removeTemplates(for: XCTemplateNamespace(namespace))
    }
}
