import Foundation
import Path

public struct ConvertFile {
    public let originalPath: Path
    public let destinationPath: Path?
    public let defaultTags: [String]
    public let tagsIfNone: [String]

    public var needsPrintProcess: Bool

    public init(originalPath: Path, destinationPath: Path?, defaultTags: [String] = [], tagsIfNone: [String] = [], needsPrintProcess: Bool = false) {
        self.originalPath = originalPath
        self.destinationPath = destinationPath
        self.defaultTags = defaultTags.map { $0.sanitizeIfNeeds() }
        self.tagsIfNone = tagsIfNone.map { $0.sanitizeIfNeeds() }
        self.needsPrintProcess = needsPrintProcess
    }

    public func convert() throws {
        let content = try convertedContent()
        if let destination = destinationPath {
            if !destination.exists {
                try destination.parent.mkdir(.p)
            }
            try content.write(to: destination)
        } else {
            try originalPath.delete()
            try content.write(to: originalPath)
        }
    }

    func convertedContent() throws -> String {
        log(print("convert!\n\(originalPath.url.path)", to: &standardError))

        let content = try String(contentsOf: originalPath)

        let frontMatter = try frontMatter(from: originalPath)
        let frontMatterString = try frontMatter.string()

        let appended = """
                       \(frontMatterString)

                       \(content)
                       """

        log(print(appended))

        return appended
    }
}

extension ConvertFile {
    static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        f.calendar = Calendar.init(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }

    func frontMatter(from filePath: Path) throws -> FrontMatter {
        var frontMatter = FrontMatter()

        frontMatter.title = try extractTitle(from: filePath)
        frontMatter.tags = try extractTags(from: filePath, defaultTags: defaultTags, tagsIfNone: tagsIfNone)

        if let date = try? extractDateFromTitle(from: filePath) {
            frontMatter.creationDate = date
        } else {
            frontMatter.creationDate = try extractCreationDate(from: filePath)
        }

        frontMatter.updatedDate = try extractUpdatedDate(from: filePath)

        return frontMatter
    }

    func extractTags(from filePath: Path, defaultTags: [String], tagsIfNone: [String]) throws -> [String] {
        var tags = try filePath.url.tagNames() ?? []

        if tags.isEmpty {
            tags += tagsIfNone
        }

        tags += defaultTags

        return tags
    }

    func extractTitle(from filePath: Path) throws -> String {
        let content = try String(contentsOf: filePath)
        guard let range = content.range(of: "# ") else {
            return ""
        }

        let lineRange = content.lineRange(for: range)
        let title = String(content[lineRange].dropFirst(2)).trimmingCharacters(in: .whitespacesAndNewlines)
        return #""\#(title)""#
    }

    func extractDateFromTitle(from filePath: Path) throws -> Date? {
        let title = try extractTitle(from: filePath)
        guard !title.isEmpty else {
            return nil
        }

        let regex = try NSRegularExpression(pattern: #"\s(\d{4}/\d{2}/\d{2})"#, options: [])
        guard let match = regex.firstMatch(in: title, options: [], range: NSRange.init(location: 0, length: title.count)) else {
            return nil
        }

        let dateString = (title as NSString).substring(with: match.range(at: 1))

        return Self.dateFormatter.date(from: dateString)
    }

    func extractCreationDate(from filePath: Path) throws -> Date {
        guard let date = filePath.ctime else {
            return Date()
        }

        return date
    }

    func extractUpdatedDate(from filePath: Path) throws -> Date {
        guard let date = filePath.mtime else {
            return Date()
        }

        return date
    }

    private func log(_ closure: @autoclosure () -> Void) {
        if needsPrintProcess {
            closure()
        }
    }
}

private extension String {
    func sanitizeIfNeeds() -> String {
        let charSet: CharacterSet = .whitespaces
        if self.contains(characterSet: charSet) {
            return self.components(separatedBy: charSet).joined(separator: "_")
        }

        return self
    }

    func contains(characterSet: CharacterSet) -> Bool {
        if self.rangeOfCharacter(from: characterSet) == nil {
            return false
        }
        return true
    }
}
