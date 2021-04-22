
import Foundation

extension URL {

    var isTemplate: Bool {
        pathExtension == "xctemplate"
    }

    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    }
}
