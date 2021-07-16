
import Foundation

class XCSnippetFileSummaryTagger {

    private let marker = "Namespace: "

    func clearTags(_ content: String) -> String {
        let scanner = Scanner(string: content)
        scanner.charactersToBeSkipped = []
        var sanitized = ""
        scanner.skipNamespaces(marker: marker)
        while let remaining = scanner.scanUpToString(marker) {
            sanitized += remaining
            scanner.skipNamespaces(marker: marker)
        }
        if let end = scanner.scanToEnd() {
            sanitized += end
        }
        sanitized = sanitized.trimmingCharacters(in: .whitespacesAndNewlines)
        return sanitized
    }

    func tag(_ content: String, tag: String) -> String {
        var result = clearTags(content)
        if !result.isEmpty && !result.hasSuffix("\n") {
            result += "\n"
        }
        result += "\(marker)\(tag)"
        return result
    }

    func tag(in content: String) -> String? {
        let scanner = Scanner(string: content)
        if let tag = scanner.scanNamespace(marker: marker) {
            return tag
        } else if scanner.scanUpToString(marker) != nil {
            return scanner.scanNamespace(marker: marker)
        } else {
            return nil
        }
    }
}

private extension Scanner {

    func skipNamespaces(marker: String) {
        while scanNamespace(marker: marker) != nil {
            _ = scanCharacters(from: .whitespacesAndNewlines)
        }
    }

    func scanNamespace(marker: String) -> String? {
        guard scanString(marker) != nil else { return nil }
        if let namespace = scanUpToCharacters(from: .whitespacesAndNewlines) {
            return namespace
        } else {
            return scanToEnd()
        }
    }

    func scanToEnd() -> String? {
        guard !isAtEnd else { return nil }
        let current = currentIndex
        while scanCharacter() != nil {}
        return String(string[current..<string.endIndex])
    }
}
