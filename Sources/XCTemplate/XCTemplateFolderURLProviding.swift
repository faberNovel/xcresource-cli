//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 29/03/2021.
//

import Foundation

public enum XCTemplateFolder {
    case xcodeDestination
    case templates(namespace: String)
    case workingDirectory
}

public protocol XCTemplateFolderURLProviding {
    func url(for folder: XCTemplateFolder) -> URL
}
