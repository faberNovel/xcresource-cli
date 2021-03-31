//
//  InstallTemplatesCommand.swift
//  
//
//  Created by Gaétan Zanella on 30/04/2020.
//

import Foundation
import ArgumentParser
import XCTemplate

struct InstallTemplatesCommand: ParsableCommand {

    enum Error: Swift.Error {
        case invalidURL
    }

    @Option(
        name: .shortAndLong,
        help: "The templates Git repository url. <url> can be a local directory path: ./src/my_template_repo."
    )
    var url: String = "https://github.com/faberNovel/CodeSnippet_iOS.git"

    @Option(
        name: .shortAndLong,
        help: "Namespaces are not visible in Xcode. A namespace acts as an installation folder. The templates will be installed inside it. If the namespace already exists, it is replaced."
    )
    var namespace: String = "FABERNOVEL"

    @Option(
        name: .shortAndLong,
        help: "The templates subdirectory path inside the repository."
    )
    var templatesPath: String = "XCTemplate"

    @Option(
        name: .shortAndLong,
        help: "The targeted repo pointer (branch or tag)."
    )
    var pointer: String = "master"

    public static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: "Install Xcode templates."
    )

    // MARK: - ParsableCommand

    func run() throws {
        guard let url = URL(string: url) else {
            throw Error.invalidURL
        }
        let templateNamespace = XCTemplateNamespace(namespace)
        let cli = XCTemplateCLI()
        try cli.downloadTemplates(
            for: templateNamespace,
            from: .git(
                url: url,
                reference: GitReference(pointer),
                folderPath: templatesPath
            )
        )
        let folder = try cli.templateFolder(for: templateNamespace)
        print("\(folder.templateCount()) successfully installed 🎉")
    }
}
