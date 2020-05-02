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

    @Option(name: .shortAndLong)
    var localPath: String?

    @Option(name: .shortAndLong, default: "https://github.com/gaetanzanella/XCTemplate.git")
    var url: String?

    @Option(name: .shortAndLong, default: "FABERNOVEL")
    var nameSpace: String

    @Option(name: .shortAndLong, default: "XCTemplate")
    var sourceDirectory: String

    @Option(name: .shortAndLong)
    var tag: String?

    @Option(name: .shortAndLong, default: "master")
    var branch: String?

    public static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: "Generate a blog post banner from the given input"
    )

    private var fileManager: FileManager { .default }

    // MARK: - ParsableCommand

    func run() throws {
        let workingDirectory = fileManager.url(for: .workingDirectory)
        defer {
            try? fileManager.removeItem(at: workingDirectory)
        }
        let templatesUrl: URL
        if let local = localPath {
            templatesUrl = URL(fileURLWithPath: local)
        } else if let url = url {
            templatesUrl = workingDirectory.appendingPathComponent(sourceDirectory)
            try downloadTemplates(fromURL: url, at: templatesUrl)
        } else {
            throw Error.invalidArguments
        }
        let urls = try fileManager.contentsOfDirectory(
            at: templatesUrl,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
        let root = fileManager.url(for: .xcodeDestination)
        let target = root.appendingPathComponent(nameSpace)
        try? fileManager.removeItem(at: target)
        try fileManager.createDirectory(at: target, withIntermediateDirectories: true)
        try urls.forEach { folder in
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
