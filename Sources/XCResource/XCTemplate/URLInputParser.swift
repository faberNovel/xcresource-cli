//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 21/07/2021.
//

import Foundation

class URLInputParser {

    enum ParsingError: Error {
        case invalidURL
    }

    func absoluteURL(fromInput url: String) throws -> URL {
        let resultURL: URL
        // Issue #7: Handling relative URLs
        let fileURL = URL(fileURLWithPath: url)
        if url.hasPrefix("~") {
            resultURL = expandTildeInPath(url)
        } else if url.hasPrefix("/") || fileURL.isReachable() {
            resultURL = fileURL
        } else if let url = URL(string: url) {
            resultURL = url
        } else {
            throw ParsingError.invalidURL
        }
        return resultURL.absoluteURL
    }

    private func expandTildeInPath(_ path: String) -> URL {
        URL(fileURLWithPath: NSString(string: path).expandingTildeInPath).standardized
    }
}

private extension URL {

    func isReachable() -> Bool {
        do {
            return try checkResourceIsReachable()
        } catch {
            return false
        }
    }
}
