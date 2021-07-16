
import Foundation

class XCSnippetCoder {

    enum CodingError: Error {
        case invalidData
    }

    func decodeSnippet(from data: Data) throws -> [String: Any] {
        guard let file = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            throw CodingError.invalidData
        }
        return file
    }

    func encodeSnippet(_ snippet: [String: Any]) throws -> Data {
        try PropertyListSerialization.data(fromPropertyList: snippet, format: .xml, options: .zero)
    }
}
