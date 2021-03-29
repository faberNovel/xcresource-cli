//
//  InstallTemplatesCommand.swift
//  
//
//  Created by Gaétan Zanella on 30/04/2020.
//

import Foundation

public struct InstallTemplatesCommand {

    public let url: String
    public let namespace: String
    public let templatesPath: String
    public let pointer: String
    private let fileManager: FileManager
    private let urlProviding: XCTemplateFolderURLProviding

    // MARK: - Life Cycle

    public init(url: String,
                namespace: String,
                templatesPath: String,
                pointer: String,
                fileManager: FileManager,
                urlProviding: XCTemplateFolderURLProviding) {
        self.url = url
        self.namespace = namespace
        self.templatesPath = templatesPath
        self.pointer = pointer
        self.fileManager = fileManager
        self.urlProviding = urlProviding
    }

    // MARK: - InstallTemplatesCommand

    public func run() throws {
        let workingDirectory = urlProviding.url(for: .workingDirectory)
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
        let target = urlProviding.url(for: .templates(namespace: namespace))
        try? fileManager.removeItem(at: target)
        try fileManager.createDirectory(at: target, withIntermediateDirectories: true)
        try templateUrls.forEach { folder in
            let folderDestination = target.appendingPathComponent(folder.lastPathComponent)
            try fileManager.copyItem(at: folder, to: folderDestination)
        }
        let count = (try? CountTemplatesCommand(url: target, fileManager: fileManager).countTemplates()) ?? 0
        print("Successfully installed \(count) templates 🎉")
    }

    // MARK: - Private

    private func downloadTemplates(fromURL url: String, at location: URL) throws {
        let command: ShellCommand = .gitDownload(url: url, reference: pointer, destionation: location.path)
        let shell = Shell()
        try shell.execute(command)
    }
}
