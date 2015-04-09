module.exports =
  config:
    executableDir:
      type: 'string'
      default: ''
      description: 'Specify unique path to slimrb if not found in environment'
    binaryName:
      type: 'string'
      default: 'slimrb'
      description: 'You might need a different binary name for slimrb'
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
    console.log 'activate linter-slim'
