//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 30/03/2021.
//

import Foundation

extension FileManager {

    func createTemporarySubdirectory() throws -> URL {
        let url = temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return url
    }
}
