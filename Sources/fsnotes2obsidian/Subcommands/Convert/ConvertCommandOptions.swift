import Foundation
import ArgumentParser
import Path

struct ConvertCommandOptions: ParsableArguments {
    @Option(name: .customLong("fsnotes-dir"), help: ArgumentHelp("The directory containing the FSNotes markdown files. Only markdown files with the `md` file extension will be processed.", valueName: "Directory Path"))
    var fsNotesDirectory: Path

    @Option(name: .customLong("output-dir"), help: ArgumentHelp("Output directory", valueName: "Directory Path"))
    var outputDirectory: Path?

    @Option(name: .customLong("tag-if-none"), parsing: .unconditionalSingleValue, help: ArgumentHelp("The tag to be given if the original file does not have one. Use the same option to specify multiple tags. Spaces will be replaced with underscores.", valueName: "String"))
    var tagsIfNone: [String] = []

    @Option(name: .customLong("tag"), parsing: .unconditionalSingleValue, help: ArgumentHelp("The tag that will always be given regardless of the tag in the original file. Use the same option to specify multiple tags. Spaces will be replaced with underscores.", valueName: "String"))
    var defaultTags: [String] = []

    @Flag(name: .customLong("in-place"), help: "Modify files directly")
    var inPlace: Bool = false

    func validate() throws {
        if outputDirectory == nil {
            guard inPlace else {
                throw "If '--output-dir' is not specified, use the '--in-place' option."
            }
        }
    }
}
