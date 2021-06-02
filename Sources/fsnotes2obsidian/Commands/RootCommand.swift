import Foundation
import ArgumentParser
import fsnotes2obsidianCore

struct RootCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "fsnotes2obsidian",
        abstract: "FSNotes の Markdown を Obsidian 向けの移行サポートツール",
        discussion: "DISCUSSION HERE",
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
