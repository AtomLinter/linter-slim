linter-slim
=========================

This linter plugin for [Linter](https://github.com/AtomLinter/Linter) provides an interface to [slim](https://github.com/slim-template/slim/). It will be used with files that have the “Ruby Slim” syntax.

## Installation
Linter package must be installed in order to use this plugin. If Linter is not installed, please follow the instructions [here](https://github.com/AtomLinter/Linter).

### slim installation
Before using this plugin, you must ensure that `slimrb` is installed on your system. To install `slimrb`, do the following:

1. Install [ruby](https://www.ruby-lang.org/).

2. Install [slim](https://github.com/slim-template/slim/) by typing the following in a terminal:
   ```
   gem install slim
   ```

Now you can proceed to install the linter-slim plugin.

### Plugin installation
```
$ apm install linter-slim
```

## Settings
You can configure linter-slim by editing ~/.atom/config.cson (choose Open Your Config in Atom menu):

```
'linter-slim':
  'slimExecutableDir': null # slimrb directory path.
  'binaryName': slimrb # slimrb binary name.
  'rails': true # generates rails compatible code.
  'library': [] # load library or plugin (e.g. slim/plugin).
```
Run `which slimrb` to find the path,
if you using rbenv run `rbenv which slimrb`
