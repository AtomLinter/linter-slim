module.exports =
  config:
    slimExecutableDir:
      type: 'string'
      default: ''
      description: 'Specify unique path to slimrb if not found in environment'
    binaryName:
      type: 'string'
      default: 'slimrb'
      description: 'You might need a different binary name for slimrb'
    rails:
      description: 'Generates rails compatible code'
      type: 'boolean'
      default: 'true'
    library:
      description: 'List modules to require (e.g. slim/smart)'
      type: 'array'
      default: []
      items:
        type: 'string'

  activate: ->
    console.log 'activate linter-slim'
