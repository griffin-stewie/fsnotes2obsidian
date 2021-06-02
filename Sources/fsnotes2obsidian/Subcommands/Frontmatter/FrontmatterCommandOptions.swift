import Foundation
import ArgumentParser
import Path

struct FrontmatterCommandOptions: ParsableArguments {
    @Option(name: .customLong("fsnotes-dir"), help: ArgumentHelp("The directory containing the FSNotes markdown files. Only markdown files with the `md` file extension will be processed.", valueName: "Directory Path"))
    var fsNotesDirectory: Path

    @Flag(name: .customLong("only-duplicates"), help: "Only output files that contain multiple Front Matter.")
    var onlyDuplicates: Bool = false
}
