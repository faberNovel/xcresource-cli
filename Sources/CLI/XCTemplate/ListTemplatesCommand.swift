
import Foundation
import ArgumentParser
import XCResource

struct ListTemplatesCommand: ParsableCommand {

    @Option(
        name: .shortAndLong,
        help: "The template namespace to list. All namespaces are listed if not specified."
    )
    var namespace: String?

    public static let configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List Xcode templates."
    )

    // MARK: - ParsableCommand

    func run() throws {
        let folder = try XCTemplateCLI().templateFolder(namespace: namespace)
        if folder.isEmpty() {
            print("No templates installed")
        } else {
            folder.describe()
        }
    }
}

private extension XCTemplateFolder {

    func describe(depth: Int = 0) {
        if depth > 0 {
            let prefix = (0..<depth).reduce(into: "", { r, _ in r += "#" })
            print(prefix, "\(name)")
        }
        templates.forEach { template in
            print("~>", template.name)
        }
        folders.forEach { folder in
            folder.describe(depth: depth + 1)
        }
    }
}
