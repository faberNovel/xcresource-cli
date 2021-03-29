//
//  File.swift
//  
//
//  Created by Gaétan Zanella on 15/05/2020.
//

import Foundation

struct CountTemplatesCommand {

    let url: URL

    private var fileManager: FileManager { .default }

    // MARK: - Public

    func countTemplates() throws -> Int {
        try recursivelyCountTemplates(at: url)
    }

    // MARK: - Private

    private func recursivelyCountTemplates(at url: URL) throws -> Int {
        if url.isTemplate {
            return 1
        }
        if url.isDirectory {
            return try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil
            )
                .reduce(into: 0, { r, url in
                    r += try recursivelyCountTemplates(at: url)
                }
            )
        }
        return 0
    }
}
