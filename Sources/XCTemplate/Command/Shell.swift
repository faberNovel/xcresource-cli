//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 30/04/2020.
//

import Foundation

typealias GitReference = String

enum ShellCommand {
    case gitDownload(url: String, reference: GitReference, destionation: String)
}

struct Shell {

    private struct Error: Swift.Error {
        let output: String
    }

    func execute(_ command: ShellCommand) throws {
        try shell(command.shell())
    }

    @discardableResult
    private func shell(_ command: String) throws -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        task.waitUntilExit()
        if task.terminationStatus != 0 {
            throw Error(output: output)
        }
        return output
    }
}

private extension ShellCommand {

    func shell() -> String {
        switch self {
        case let .gitDownload(url, reference, destination):
            return "git clone -b '\(reference)' --single-branch --depth 1 \(url) \(destination)"
        }
    }
}
