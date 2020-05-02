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
        case workingDirectory
    }

    func url(for folder: Folder) -> URL {
        let url: URL
        let home = homeDirectoryForCurrentUser
        switch folder {
        case .xcodeDestination:
            url = URL(fileURLWithPath: "Library/Developer/Xcode/Templates/", relativeTo: home)
        case .workingDirectory:
            url = temporaryDirectory.appendingPathComponent("XCTemplateInstaller")
        }
        try? createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
