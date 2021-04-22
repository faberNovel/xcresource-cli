
import Foundation
@testable import XCTemplate

class GitRepository {

    let url: URL
    let shell: Shell

    init(url: URL) {
        self.url = url
        self.shell = Shell()
        FileManager.default.createDirectoryIfNeeded(at: url)
        shell.changeCurrentDirectoryPath(url.path)
    }

    func initialize() {
        try! shell.execute("git init")
    }

    func commit(message: String) {
        try! shell.execute("git commit -m \"\(message)\"")
    }

    func tag(_ tag: String) {
        try! shell.execute("git tag \(tag)")
    }

    func stageAll() {
        try! shell.execute("git add .")
    }

    func checkoutBranch(_ branch: String) {
        try! shell.execute("git checkout \(branch)")
    }

    func checkoutNewBranch(_ branch: String) {
        try! shell.execute("git checkout -b \(branch)")
    }
}
