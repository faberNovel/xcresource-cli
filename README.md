# xctemplate

A Xcode template manager.

## Requirements

- Swift 5.2
- Xcode 11.4 or later

## Installation

### Homebrew

Run the following command to install using Homebrew:

```
$ brew install faberNovel/formulae/xctemplate
```

### Manually

Run the following commands to build and install manually:
```
$ git clone https://github.com/faberNovel/xctemplate-cli
$ cd xctemplate-cli
$ make install
```

## Usage

```
OVERVIEW: A Swift command-line tool to manage Xcode templates.

USAGE: xctemplate <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  install                 Install Xcode templates.
  remove                  Remove Xcode templates.
  list                    List Xcode templates.
  ```

### xctemplate install

```
OVERVIEW: Install Xcode templates.

USAGE: xctemplate install [--url <url>] [--namespace <namespace>] [--templates-path <templates-path>] [--tag <tag>] [--branch <branch>]

OPTIONS:
  -u, --url <url>         The templates repository url. (default: https://github.com/faberNovel/XCTemplate.git)
  -n, --namespace <namespace>
                          A namespace acts as an installation folder. The templates will be installed inside it. If the namespace already exists, it is replaced. (default: FABERNOVEL)
  -t, --templates-path <templates-path>
                          The templates directory path inside the repository. (default: XCTemplate)
  -t, --tag <tag>         The tag target.
  -b, --branch <branch>   The branch target. (default: master)
  -h, --help              Show help information.
```

Running `xctemplate install` installs the Fabernovel templates under the `FABERNOVEL` namespace.

### xctemplate list

```
OVERVIEW: List Xcode templates.

USAGE: xctemplate list [--namespace <namespace>]

OPTIONS:
  -n, --namespace <namespace>
                          The template namespace to list. All namespaces are listed if not specified.
  -h, --help              Show help information.
```

### xctemplate remove

```
OVERVIEW: Remove Xcode templates.

USAGE: xctemplate remove [--namespace <namespace>]

OPTIONS:
  -n, --namespace <namespace>
                          The template namespace to delete. (default: FABERNOVEL)
  -h, --help              Show help information.
```
