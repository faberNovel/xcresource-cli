# xcresource

A Xcode resource manager. Use it to download Xcode templates or snippets from git repositories. 

## Requirements

- Swift 5.2
- **Xcode 11.4** or later
- macOS 10.5

## Installation

### Homebrew

Run the following command to install using Homebrew:

```
$ brew install fabernovel/formulae/xcresource
```
(this will also install the `cmake` dependency)

To uninstall it:
```
$ brew uninstall xcresource
```

### Manually

Run the following commands to build and install manually:
```
$ git clone https://github.com/faberNovel/xcresource-cli
$ cd xcresource-cli
$ make install
```

## Usage

```
OVERVIEW: A Swift command-line tool to manage Xcode resources.

USAGE: xcresource <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  template                A Swift command-line tool to manage Xcode templates.
  snippet                 A Swift command-line tool to manage Xcode snippets.
  ```

### xcresource template

```
OVERVIEW: A Swift command-line tool to manage Xcode templates.

USAGE: xcresource template <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  install                 Install Xcode templates from a git repository.
  remove                  Remove Xcode templates.
  list                    List Xcode templates.
  open                    Open Xcode templates folder.
```

Running `xctemplate template install` installs the [Fabernovel templates](https://github.com/faberNovel/CodeSnippet_iOS/blob/master/CodeSnippet.md) under the `FABERNOVEL` namespace.

### xctemplate snippet

```
OVERVIEW: A Swift command-line tool to manage Xcode snippets.

USAGE: xcresource snippet <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  install                 Install Xcode snippets from a git repository.
  remove                  Remove Xcode snippet.
  list                    List Xcode snippet.
  open                    Open Xcode snippets folder.
```

## Contributing

### To test

```
make install
```
