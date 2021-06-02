import Foundation
import ArgumentParser
import Path
import fsnotes2obsidianCore

struct ConvertCommand: ParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "convert",
        abstract: "タグなどを Front Matter に変換",
        discussion: "DISCUSSION HERE"
    )

    @OptionGroup()
    var options: ConvertCommandOptions

    func run() throws {
        try run(options: options)
        throw ExitCode.success
    }
}

extension ConvertCommand {
    private func run(options: ConvertCommandOptions) throws {
        try options.outputDirectory?.mkdir(.p)
        
        let files = try convertFiles(
            fsNotesDirectory: options.fsNotesDirectory,
            destinationDirectory: options.inPlace ? nil : options.outputDirectory!
        )
        
        for file in files {
            try file.convert()
        }
    }
    
    private func convertFiles(fsNotesDirectory: Path, destinationDirectory: Path?) throws -> [ConvertFile] {
        let fileURLs = FSNotes2Obsidian.markdownFileURLs(from: fsNotesDirectory)
        
        let destinationPaths: [Path?]
        if let destinationDirectory = destinationDirectory {
            destinationPaths = fileURLs.map { original -> Path in
                destinationDirectory/original.relativePath
            }
        } else {
            // create an array contains nil value for zipping later step.
            destinationPaths = Array(repeating: nil, count: fileURLs.count)
        }
        
        let filePaths = fileURLs.map { Path.init(url: $0)! }
        
        let verbose = Logger.shard.verbose
        
        let files = zip(filePaths, destinationPaths).map { (original, destination) -> ConvertFile in
            ConvertFile(
                originalPath: original,
                destinationPath: destination,
                defaultTags: options.defaultTags,
                tagsIfNone: options.tagsIfNone,
                needsPrintProcess: verbose
            )
        }
                
        return files
    }
}
