linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"

class LinterSlim extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['text.slim']

  executablePath: null

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: ['slimrb', '--compile']

  linterName: 'slim'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '(?m)Slim::Parser::(?<error>SyntaxError): (?<message>.+)\n' +
    '.+, Line (?<line>\\d+), Column (?<col>\\d+)'

  errorStream: 'stderr'

  constructor: (editor)->
    super(editor)

    atom.config.observe 'linter-slim.executableDir', =>
      executableDir = atom.config.get 'linter-slim.executableDir'

      if executableDir
        @executablePath = if executableDir.length > 0
          executableDir
        else
          null

    atom.config.observe 'linter-slim.rails', =>
      @updateCommand()

    atom.config.observe 'linter-slim.binaryName', =>
      @updateCommand()

    atom.config.observe 'linter-slim.library', =>
      @updateCommand()

  destroy: ->
    atom.config.unobserve 'linter-slim.binaryName'
    atom.config.unobserve 'linter-slim.executableDir'
    atom.config.unobserve 'linter-slim.rails'
    atom.config.unobserve 'linter-slim.library'

  updateCommand: ->
    binary_name = atom.config.get 'linter-slim.binaryName'
    rails = atom.config.get 'linter-slim.rails'
    library = atom.config.get 'linter-slim.library'

    cmd = [binary_name, '--compile']

    cmd.push '--rails' if rails

    if library and library.length > 0
      cmd.push '-r', library for library in library

    @cmd = cmd

module.exports = LinterSlim
