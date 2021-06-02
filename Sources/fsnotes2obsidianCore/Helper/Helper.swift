import Foundation
import Path

public enum FSNotes2Obsidian {
    public static func markdownFileURLs(from dir: Path) throws -> [URL] {
        let fs = FileManager.default
        guard let dirEnum = fs.enumerator(atPath: dir.string) else {
            throw "The directory does not exist."
        }

        let files = dirEnum.compactMap { (file) -> URL? in
            guard let file = file as? String else {
                return nil
            }

            guard file.hasSuffix(".md") else {
                return nil
            }


            return URL(fileURLWithPath: file, relativeTo: dir.url)
        }

        return files
    }
}

public extension FSNotes2Obsidian {
    static func frontmatter(of file: URL) throws -> String? {
        return frontmatter(of: try String(contentsOf: file))
    }

    static func frontmatter(of file: Path) throws -> String? {
        return frontmatter(of: try String(contentsOf: file))
    }

    static func frontmatter(of content: String) -> String? {
        let regex = try! NSRegularExpression(pattern: #"((-{3})\n((.+?):\s.+?\n)+(-{3}))"#, options: [])
        guard let match = regex.firstMatch(in: content, options: [], range: NSRange.init(location: 0, length: content.count)) else {
            return nil
        }

        let string = (content as NSString).substring(with: match.range(at: 1))
        return string
    }
}

public extension FSNotes2Obsidian {
    static func frontmatters(of file: URL) throws -> [String] {
        return frontmatters(of: try String(contentsOf: file))
    }

    static func frontmatters(of file: Path) throws -> [String] {
        return frontmatters(of: try String(contentsOf: file))
    }

    static func frontmatters(of content: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: #"((-{3})\n((.+?):\s.+?\n)+(-{3}))"#, options: [])
        let matches = regex.matches(in: content, options: [], range: NSRange.init(location: 0, length: content.count))

        guard !matches.isEmpty else {
            return []
        }

        return matches.map { match in
            (content as NSString).substring(with: match.range(at: 1))
        }
    }
}
