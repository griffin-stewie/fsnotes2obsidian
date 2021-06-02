import Foundation

public struct FrontMatter {
    public var title: String = ""
    public var creationDate: Date = Date()
    public var updatedDate: Date? = nil
    public var tags: [String] = []
    public var fileType: FileType = .note
    public var aliases: [String] = []

    public func string() throws -> String {
        return yamlFormatString(surroundDashes: true)
    }

    private func yamlFormatString(surroundDashes: Bool = false) -> String {
        var str: String = ""
        print("title", title, separator: ": ", terminator: "\n", to: &str)
        print("date", Self.dateFormatter.string(from: creationDate), separator: ": ", terminator: "\n", to: &str)

        if let updatedDate = updatedDate, creationDate.isDifferentDay(updatedDate) {
            print("update", Self.dateFormatter.string(from: updatedDate), separator: ": ", terminator: "\n", to: &str)
        }

        print("type", fileType.rawValue, separator: ": ", terminator: "\n", to: &str)
        print("tags", tags.yamlArrayRepresentation(), separator: ": ", terminator: "\n", to: &str)
        print("aliases", aliases.yamlArrayRepresentation(), separator: ": ", terminator: "\n", to: &str)

        str = str.trimmingCharacters(in: .whitespacesAndNewlines)

        if surroundDashes {
            str = """
                ---
                \(str)
                ---
                """
        }

        return str
    }
}

extension FrontMatter {
    static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.calendar = Calendar.init(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }
}

private extension Array where Element == String {
    func yamlArrayRepresentation() -> String {
        return "[\(self.joined(separator: ", "))]"
    }
}

private extension Date {
    func isDifferentDay(_ date: Date) -> Bool {
        return !isSameDay(date)
    }

    func isSameDay(_ date: Date) -> Bool {
        let lhs = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let rhs = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return lhs == rhs
    }
}