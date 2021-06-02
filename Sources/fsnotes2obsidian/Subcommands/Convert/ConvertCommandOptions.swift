import Foundation
import ArgumentParser
import Path

struct ConvertCommandOptions: ParsableArguments {
    @Option(name: .customLong("fsnotes-dir"), help: ArgumentHelp("FSNotes のマークダウンファイルが入ったディレクトリ", valueName: "Directory Path"))
    var fsNotesDirectory: Path
    
    @Option(name: .customLong("output-dir"), help: ArgumentHelp("変換結果出力先ディレクトリ", valueName: "Directory Path"))
    var outputDirectory: Path?
    
    @Option(name: .customLong("tag-if-none"), parsing: .unconditionalSingleValue, help: ArgumentHelp("元ファイルにタグがない場合に付与されるタグ。複数指定は同じオプションを使ってください。スペースはアンダースコアに置換されます。", valueName: "String"))
    var tagsIfNone: [String] = []
    
    @Option(name: .customLong("tag"), parsing: .unconditionalSingleValue, help: ArgumentHelp("元ファイルのタグにかかわらず必ず付与されるタグ。複数指定は同じオプションを使ってください。スペースはアンダースコアに置換されます。", valueName: "String"))
    var defaultTags: [String] = []
    
    @Flag(name: .customLong("in-place"), help: "直接ファイルを変更")
    var inPlace: Bool = false
    
    func validate() throws {
        if outputDirectory == nil {
            guard inPlace else {
                throw "'--output-dir' の指定をしない場合は '--in-place' オプションを使用してください。"
            }
        }
    }
}
