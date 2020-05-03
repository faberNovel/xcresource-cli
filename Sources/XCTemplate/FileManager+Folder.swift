//
//  FileManager+Folder.swift
//  
//
//  Created by Gaétan Zanella on 30/04/2020.
//

import Foundation

extension FileManager {

    enum Folder {
        case xcodeDestination
        case templates(namespace: String)
        case workingDirectory
    }

    func url(for folder: Folder) -> URL {
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
