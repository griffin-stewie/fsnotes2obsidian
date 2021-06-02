import Foundation
import ArgumentParser
import fsnotes2obsidianCore

struct RootCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "fsnotes2obsidian",
        abstract: "FSNotes Markdown Migration Support Tool for Obsidian",
        version: "1.0.0",
        subcommands: [
            ConvertCommand.self,
            FrontmatterCommand.self,
        ]
    )
    @Flag(name: .long, help: "verbose")
    var verbose: Bool = false

    func validate() throws {
        Logger.shard.verbose = verbose
    }
}
