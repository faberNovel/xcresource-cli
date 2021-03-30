//
//  XCTemplateFolder.swift
//  
//
//  Created by Gaétan Zanella on 30/03/2021.
//

import Foundation

enum XCTemplateModel {
    case empty
    case threeBasicTemplates
    case templateHierarchy
}

class DynamicXCTemplateFolder {

    let rootUrl: URL
    private let fileManager: FileManager

    init(url: URL, fileManager: FileManager) {
        self.rootUrl = url.appendingPathComponent("GeneratedTemplates")
        self.fileManager = fileManager
        fileManager.createIfNeededDirectory(at: rootUrl)
    }

    func clean() {
        try? fileManager.removeItem(at: rootUrl)
    }

    func prepare(model: XCTemplateModel) {
        switch model {
        case .empty:
            break
        case .threeBasicTemplates:
            generateRootTemplate(name: "Template1")
            generateRootTemplate(name: "Template2")
            generateRootTemplate(name: "Template3")
        case .templateHierarchy:
            generateRootTemplate(name: "Template1")
            generateRootTemplate(name: "Template2")
            let folder = rootUrl.appendingPathComponent("Template")
            fileManager.createIfNeededDirectory(at: folder)
            generateTemplate(name: "Template3", at: folder)
            generateTemplate(name: "Template4", at: folder)
        }
    }

    private func generateRootTemplate(name: String) {
        generateTemplate(name: name, at: rootUrl)
    }

    private func generateTemplate(name: String, at url: URL) {
        let target = url.appendingPathComponent(name).appendingPathExtension("xctemplate")
        print(target)
        fileManager.createFile(atPath: target.path, contents: nil, attributes: nil)
    }
}
