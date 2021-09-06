
import Foundation

public struct GitReference {

    let name: String

    public init(_ name: String) {
        self.name = name
    }
}

enum ShellCommand {
    case open(path: String)
    case gitDownload(url: URL, reference: GitReference, destination: URL)
}

class Shell {

    var currentDirectoryPath = "~"

    private struct Error: Swift.Error {
        let output: String
    }

    func execute(_ command: ShellCommand) throws {
        try execute(command.shell())
    }

    func changeCurrentDirectoryPath(_ path: String) {
        currentDirectoryPath = path
    }

    @discardableResult
    func execute(_ command: String) throws -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.currentDirectoryPath = currentDirectoryPath
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
            return "git clone -b '\(reference.name)' --single-branch --depth 1 \(url.toString()) \(destination.toString())"
        case let .open(path):
            return "open \(path)"
        }
    }
}

private extension URL {

    func toString() -> String {
        if isFileURL {
            return path // we remove the file: prefix
        } else {
            return absoluteString
        }
    }
}
