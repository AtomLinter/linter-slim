linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"

class LinterSlim extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['text.slim']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'slimrb -c'

  linterName: 'slim'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '(?m)Slim::Parser::(?<error>SyntaxError): (?<message>.+)\n' +
    '.+, Line (?<line>\\d+), Column (?<col>\\d+)'

  errorStream: 'stderr'

  constructor: (editor)->
    super(editor)

    atom.config.observe 'linter-slim.slimExecutablePath', =>
      @executablePath = atom.config.get 'linter-slim.slimExecutablePath'

  destroy: ->
    atom.config.unobserve 'linter-slim.slimExecutablePath'

module.exports = LinterSlim
