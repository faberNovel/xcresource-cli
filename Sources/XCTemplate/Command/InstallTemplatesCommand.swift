//
//  InstallTemplatesCommand.swift
//  
//
//  Created by Gaétan Zanella on 30/04/2020.
//

import Foundation
import ArgumentParser

struct InstallTemplatesCommand: ParsableCommand {

    enum Error: Swift.Error {
        case invalidArguments
    }

    @Option(
        name: .shortAndLong,
        default: "https://github.com/faberNovel/CodeSnippet_iOS.git",
        help: "The templates Git repository url. <url> can be a local directory path: ./src/my_template_repo"
    )
    var url: String

    @Option(
        name: .shortAndLong,
        default: "FABERNOVEL",
        help: "Namespaces are not visible in Xcode. A namespace acts as an installation folder. The templates will be installed inside it. If the namespace already exists, it is replaced."
    )
    var namespace: String

    @Option(
        name: .shortAndLong,
        default: "XCTemplate",
        help: "The templates subdirectory path inside the repository."
    )
    var templatesPath: String

    @Option(
        name: .shortAndLong,
        default: "master",
        help: "The targeted repo branch"
    )
    var branch: String?

    @Option(
        name: .shortAndLong,
        help: "The targeted repo tag."
    )
    var tag: String?

    public static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: "Install Xcode templates."
    )

    private var fileManager: FileManager { .default }

    // MARK: - ParsableCommand

    func run() throws {
        let workingDirectory = fileManager.url(for: .workingDirectory)
        try? fileManager.removeItem(at: workingDirectory)
        defer {
            try? fileManager.removeItem(at: workingDirectory)
        }
        let repositoryUrl = workingDirectory
        print("Cloning \(url) templates…")
        try downloadTemplates(fromURL: url, at: repositoryUrl)
        let templateUrls = try fileManager.contentsOfDirectory(
            at: repositoryUrl.appendingPathComponent(templatesPath),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
        let target = fileManager.url(for: .templates(namespace: namespace))
        try? fileManager.removeItem(at: target)
        try fileManager.createDirectory(at: target, withIntermediateDirectories: true)
        try templateUrls.forEach { folder in
            let folderDestination = target.appendingPathComponent(folder.lastPathComponent)
            try fileManager.copyItem(at: folder, to: folderDestination)
        }
        let count = (try? CountTemplatesCommand(url: target).countTemplates()) ?? 0
        print("Successfully installed \(count) templates 🎉")
    }

    // MARK: - Private

    private func downloadTemplates(fromURL url: String, at location: URL) throws {
        let command: ShellCommand
        if let tag = tag {
            command = .gitDownload(url: url, reference: .tag(tag), destionation: location.path)
        } else if let branch = branch {
            command = .gitDownload(url: url, reference: .branch(branch), destionation: location.path)
        } else {
            throw Error.invalidArguments
        }
        let shell = Shell()
        try shell.execute(command)
    }
}
