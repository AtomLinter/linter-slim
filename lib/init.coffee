module.exports =
  config:
    slimExecutableDir:
      type: 'string'
      default: ''
    binaryName:
      type: 'string'
      default: 'slimrb'
      description: 'You might need a different binary name for slimrb'
    rails:
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
