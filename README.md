# fsnotes2obsidian

`fsnotes2obsidian` converts FSNotes.app's markdown files for Obsidian.

This tool works only my use-case but hopefully it helps your case as well.

## How it works

[FSNotes.app](https://fsnot.es/) version less than 4 had Tag feature using Finder's tag system. This tool will pick up tags and date information etc then appending them as Front Matter at the begining of file.

**It is highly recommended that you backup the files to be converted before using this tool.**

```sh
# Converts files
fsnotes2obsidian convert --fsnotes-dir ~/Documents/vsnotes --output-dir ~/Documents/obsidian_notes/converted --tag converted
```

## Additional Tips

`fsnotes2obsidian` won't remove existing Front Matter. Converted markdown files may have 2 Front Matter parts. You can figure out which file has multiple Front Matter using command bellow.

```sh
# Converts files
fsnotes2obsidian frontmatter --only-duplicates --dir ~/Documents/obsidian_notes/converted
```

If you need completion support, you can run this command that it generates completion script for zsh. [more information here](https://github.com/apple/swift-argument-parser/blob/main/Documentation/07%20Completion%20Scripts.md)

```
fsnotes2obsidian --generate-completion-script zsh > ~/.zsh/completion/_fsnotes2obsidian
```
