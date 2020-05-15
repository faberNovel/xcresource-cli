//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 03/05/2020.
//

import Foundation

extension URL {

    var isTemplate: Bool {
        pathExtension == "xctemplate"
    }

    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    }
}
