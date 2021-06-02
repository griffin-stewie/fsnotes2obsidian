import Foundation
import ArgumentParser
import Path

struct FrontmatterCommandOptions: ParsableArguments {
    @Option(name: .customLong("fsnotes-dir"), help: ArgumentHelp("FSNotes のマークダウンファイルが入ったディレクトリ", valueName: "Directory Path"))
    var fsNotesDirectory: Path
    
    @Flag(name: .customLong("only-duplicates"), help: "Front Matter が複数含まれてしまったファイルのみ出力する")
    var onlyDuplicates: Bool = false
}
