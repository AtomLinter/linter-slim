module.exports =
  config:
    slimExecutableDir:
      type: 'string'
      default: ''
    binaryName:
      type: 'string'
      default: 'slimrb'
    rails:
      type: 'boolean'
      default: 'true'
    library:
      type: 'array'
      default: []
      
  activate: ->
    console.log 'activate linter-slim'
