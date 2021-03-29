//
//  FileManager+XCTemplateFolderURLProviding.swift
//  
//
//  Created by Gaétan Zanella on 29/03/2021.
//

import Foundation
import XCTemplate

extension FileManager: XCTemplateFolderURLProviding {

    public func url(for folder: XCTemplateFolder) -> URL {
        let url: URL
        switch folder {
        case .xcodeDestination:
            url = xcodeTemplateURL
        case let .templates(namespace):
            url = xcodeTemplateURL.appendingPathComponent(namespace)
        case .workingDirectory:
            url = temporaryDirectory.appendingPathComponent("XCTemplate-CLI")
        }
        try? createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    private var xcodeTemplateURL: URL {
        URL(
            fileURLWithPath: "Library/Developer/Xcode/Templates",
            relativeTo: homeDirectoryForCurrentUser
        )
    }
}
