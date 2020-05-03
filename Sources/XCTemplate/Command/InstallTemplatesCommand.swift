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
        default: "https://github.com/gaetanzanella/XCTemplate.git",
        help: "The templates repository url"
    )
    var url: String

    @Option(
        name: .shortAndLong,
        default: "FABERNOVEL",
        help: "A namespace acts as a folder. The templates will be installed inside it. If the namespace already exists, it is replaced."
    )
    var namespace: String

    @Option(
        name: .shortAndLong,
        default: "XCTemplate",
        help: "The templates directory path inside the repository"
    )
    var sourcePath: String

    @Option(
        name: .shortAndLong,
        help: "The tag target"
    )
    var tag: String?

    @Option(
        name: .shortAndLong,
        default: "master",
        help: "The branch target"
    )
    var branch: String?

    public static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: "Install Xcode templates"
    )

    private var fileManager: FileManager { .default }

    // MARK: - ParsableCommand

    func run() throws {
        let workingDirectory = fileManager.url(for: .workingDirectory)
        defer {
            try? fileManager.removeItem(at: workingDirectory)
        }
        let repositoryUrl = workingDirectory
        try downloadTemplates(fromURL: url, at: repositoryUrl)
        let templateUrls = try fileManager.contentsOfDirectory(
            at: repositoryUrl.appendingPathComponent(sourcePath),
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
