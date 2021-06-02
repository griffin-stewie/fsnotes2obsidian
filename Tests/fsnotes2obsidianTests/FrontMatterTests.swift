import XCTest
import class Foundation.Bundle
import Path
@testable import fsnotes2obsidianCore

final class FrontMatterTests: XCTestCase {

    lazy var file: ConvertFile = ConvertFile(originalPath: inputFile, destinationPath: Path("~/")!)

    lazy var fileWithoutTags: ConvertFile = ConvertFile(originalPath: inputFileWithoutTags, destinationPath: Path("~/")!)

    lazy var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        f.calendar = Calendar.init(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    func testExtractTags() throws {
        do {
            let tags = try file.extractTags(from: inputFile, defaultTags: [], tagsIfNone: [])

            XCTAssertEqual(tags.count, 1)
            XCTAssertEqual(tags[0], "勉強会")
        }

        do {
            let defaultTag = "Imported"
            let tags = try file.extractTags(from: inputFile, defaultTags: [defaultTag], tagsIfNone: [])

            XCTAssertEqual(tags.count, 2)
            XCTAssertEqual(tags[0], "勉強会")
            XCTAssertEqual(tags[1], defaultTag)
        }

        do {
            let tagIfNone = "tagIfNone"
            let defaultTag = "Imported"
            let tags = try file.extractTags(from: inputFile, defaultTags: [defaultTag], tagsIfNone: [tagIfNone])

            XCTAssertEqual(tags.count, 2)
            XCTAssertEqual(tags[0], "勉強会")
            XCTAssertEqual(tags[1], defaultTag)
        }

        do {
            let tagIfNone = "tagIfNone"
            let defaultTag = "Imported"
            let tags = try fileWithoutTags.extractTags(from: inputFileWithoutTags, defaultTags: [defaultTag], tagsIfNone: [tagIfNone])

            XCTAssertEqual(tags.count, 2)
            XCTAssertEqual(tags[0], tagIfNone)
            XCTAssertEqual(tags[1], defaultTag)
        }

        do {
            let tagIfNone = "tagIfNone"
            let tags = try fileWithoutTags.extractTags(from: inputFileWithoutTags, defaultTags: [], tagsIfNone: [tagIfNone])

            XCTAssertEqual(tags.count, 1)
            XCTAssertEqual(tags[0], tagIfNone)
        }
    }

    func testExtractTitle() throws {
        let title = try file.extractTitle(from: inputFile)
        XCTAssertEqual(title, #""これはタイトルです 2021/03/04""#)
    }

    func testExtractDateFromTitle() throws {
        let date = try file.extractDateFromTitle(from: inputFile)
        XCTAssertNotNil(date)
        XCTAssertEqual(dateFormatter.string(from: date!), "2021/03/04")
    }

    func testExtractCreationDate() throws {
        let date = try file.extractCreationDate(from: inputFile)
        XCTAssertEqual(dateFormatter.string(from: date), "2020/02/04")
    }

    func testExtractUpdatedDate() throws {
        let date = try file.extractUpdatedDate(from: inputFile)
        XCTAssertEqual(dateFormatter.string(from: date), "2021/06/02")
    }

    func testFrontMatterInstance() throws {
        let frontMatter = try file.frontMatter(from: inputFile)
        XCTAssertEqual(frontMatter.title, #""これはタイトルです 2021/03/04""#)
        XCTAssertEqual(dateFormatter.string(from: frontMatter.creationDate), "2021/03/04")
        XCTAssertEqual(dateFormatter.string(from: frontMatter.updatedDate!), "2021/06/02")
        XCTAssertEqual(frontMatter.tags, ["勉強会"])
        XCTAssertTrue(frontMatter.aliases.isEmpty)
    }

    func testFrontMatterOutput() throws {
        let frontMatter = try file.frontMatter(from: inputFile)
        let expected = """
                    ---
                    title: "これはタイトルです 2021/03/04"
                    date: 2021-03-04
                    update: 2021-06-02
                    type: note
                    tags: [勉強会]
                    aliases: []
                    ---
                    """
        let output = try frontMatter.string()
        XCTAssertEqual(output, expected)
    }

    func testExtractFrontmatter() throws {
        let input = """
                    ---
                    title: "これはタイトルです 2021/03/04"
                    date: 2021-03-04
                    update: 2021-06-01
                    type: note
                    tags: [勉強会]
                    aliases: []
                    ---

                    # タイトル

                    description
                    """
        let expected = """
                    ---
                    title: "これはタイトルです 2021/03/04"
                    date: 2021-03-04
                    update: 2021-06-01
                    type: note
                    tags: [勉強会]
                    aliases: []
                    ---
                    """
        let output = FSNotes2Obsidian.frontmatter(of: input)
        XCTAssertNotNil(output)
        XCTAssertEqual(output, expected)
    }

    fileprivate let packageRootURL: URL = {
        let path = URL(fileURLWithPath: #file).pathComponents.prefix(while: { $0 != "Tests" }).joined(separator: "/").dropFirst()
        return URL(fileURLWithPath: String(path))
    }()

    /// Returns path to the built products directory.
    var inputFile: Path {
      #if os(macOS)

      let url = URL(fileURLWithPath: "sandbox/FromFSNotes/AC55883D-4FE6-4199-86CC-9F34FD4B11B9 20200204030408.md", relativeTo: packageRootURL)

      return Path(url: url)!
      #else
        return Bundle.main.bundleURL
      #endif
    }


    var inputFileWithoutTags: Path {
      #if os(macOS)

      let url = URL(fileURLWithPath: "sandbox/FromFSNotes/1FD6D848-04D8-4D9A-A084-850BE37E1322.md", relativeTo: packageRootURL)

      return Path(url: url)!
      #else
        return Bundle.main.bundleURL
      #endif
    }

}

