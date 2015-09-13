{CompositeDisposable} = require 'atom'
exec = require('child_process').exec
SymfonyFinder = require './symfonyFinder'

module.exports = Syfi =
  config:
    appFolderOverride:
      title: 'App folder override'
      description: "
        Define the folder where your AppKernel.php and bootstrap.php.cache is.
        If left empty, then the [first opened project's root]/app will be
        assumed.
      "
      type: 'string'
      default: ''

  subscriptions: null
  symfonyFinder: new SymfonyFinder exec, atom

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'syfi:find': => do @symfonyFinder.findSelection

  deactivate: ->
    @subscriptions.dispose()
