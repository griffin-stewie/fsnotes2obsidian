import Foundation
import ArgumentParser
import Path
import fsnotes2obsidianCore

struct FrontmatterCommand: ParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "frontmatter",
        abstract: "Front Matter があれば出力するだけ",
        discussion: "DISCUSSION HERE"
    )

    @OptionGroup()
    var options: FrontmatterCommandOptions

    func run() throws {
        try run(options: options)
        throw ExitCode.success
    }
}

extension FrontmatterCommand {
    private func run(options: FrontmatterCommandOptions) throws {
        var results = try frontmatters(in: options.fsNotesDirectory)

        if options.onlyDuplicates {
            results = results.filter({ (_, frontmatters: [String]) in
                frontmatters.count > 1
            })
        }
        
        for (url, frontmatters) in results {
            print(url.path)
            for f in frontmatters {
                print(f)
                print("")
            }
        }
    }
    
    private func frontmatters(in fsNotesDirectory: Path) throws -> [(url: URL, frontmatters: [String])] {
        let fileURLs = FSNotes2Obsidian.markdownFileURLs(from: fsNotesDirectory)

        let results = try fileURLs.compactMap { url -> (url: URL, frontmatters: [String])? in
            let frontmatters = try FSNotes2Obsidian.frontmatters(of: url)
            
            if frontmatters.isEmpty {
                return nil
            }
            
            return (url, frontmatters)
        }
        
        
        return results
    }
}
