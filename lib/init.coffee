{BufferedProcess, CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      default: 'slimrb'
      description: 'Specify unique path to slimrb if not found in environment'
    rails:
      type: 'boolean'
      default: false
      description: 'Generates rails compatible code'
    library:
      type: 'array'
      default: []
      items:
        type: 'string'
      description: 'List modules to require (e.g. slim/smart)'

  activate: ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.config.observe 'linter-slim.executablePath', (executablePath) =>
      @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-slim.rails', (rails) =>
      @rails = rails
    @subscriptions.add atom.config.observe 'linter-slim.library', (library) =>
      @library = library

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: ['text.slim']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) =>
        return new Promise (resolve, reject) =>
          result = ''
          filePath = textEditor.getPath()
          args = [filePath, '--compile']
          args.push '--rails' if @rails
          if @library and @library.length > 0
            args.push '-r', library for library in @library

          process = new BufferedProcess
            command: @executablePath
            args: args
            stderr: (data) ->
              result = data
            exit: (code) ->
              return resolve [] unless code is 0
              regexp = '(?m)Slim::Parser::(?<error>SyntaxError): (?<message>.+)\n' +
                      '.+, Line (?<line>\\d+), Column (?<col>\\d+)'

              match = regexp.exec(result)
              resolve [
                type: match[1],
                text: match[2],
                filePath: filePath,
                range: [
                  # Atom expects ranges to be 0-based
                  [match[3] - 1, match[4] - 1],
                  [match[3] - 1, match[4]]
                ]
              ]

          process.onWillThrowError ({error,handle}) ->
            atom.notifications.addError "Failed to run #{@executablePath}",
              detail: "#{error.message}"
              dismissable: true
            handle()
            resolve []
