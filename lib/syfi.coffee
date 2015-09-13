{CompositeDisposable} = require 'atom'
exec = require('child_process').exec
SymfonyFinder = require './symfonyFinder'

module.exports = Syfi =
  subscriptions: null
  symfonyFinder: new SymfonyFinder exec, atom

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'syfi:find': => do @symfonyFinder.findSelection

  deactivate: ->
    @subscriptions.dispose()
