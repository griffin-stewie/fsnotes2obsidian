import Foundation
import ArgumentParser
import Path

struct FrontmatterCommandOptions: ParsableArguments {
    @Option(name: .customLong("dir"), help: ArgumentHelp("The directory containing the markdown files. Only markdown files with the `md` file extension will be processed.", valueName: "Directory Path"))
    var markdownFilesDirectory: Path

    @Flag(name: .customLong("only-duplicates"), help: "Only output files that contain multiple Front Matter.")
    var onlyDuplicates: Bool = false
}
