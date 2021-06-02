import Foundation

extension URL {
    public func tagNames() throws -> [String]? {
        let values = try? resourceValues(forKeys: [.tagNamesKey])
        return values?.tagNames
    }
}
