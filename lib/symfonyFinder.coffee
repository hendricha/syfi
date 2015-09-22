_ = require 'underscore'

module.exports = class SymfonyFinder
  constructor: (@exec, @atom) ->

  findSelection: ->
    selection = @atom?.workspace?.paneContainer?.activePane
      ?.activeItem?.getSelectedText?()

    if not selection? or selection is ''
      return @showMessage 'Error', 'Nothing was selected'

    folder = @atom.project.rootDirectories[0].path
    @exec "#{__dirname}/../syfi-cli '#{selection}'",
      { cwd: folder, env: do @getEnvironmentValues }, @openResult

  getEnvironmentValues: ->
    if '' isnt @atom.config.get 'syfi.appFolderOverride'
      return _.extend {
        'SYMFONY_APP_FOLDER': @atom.config.get 'syfi.appFolderOverride'
      }, process.env

  openResult: (error, stdout, stderr) =>
    if @requireError error
      return @showMessage 'Error', '
        Could not find required php files. Maybe configure the app folder
        override in the syfi package settings?
      '
    if error? or stderr?.length
      throw new Error "
        syfi exec error:
        #{error?.message or ''}
        #{stderr?.toString() or ''}
      "

    if stdout.toString().trim() is ''
      return @showMessage 'Info', 'Selction could not be found'

    @atom.workspace.open stdout.toString().trim()

  requireError: (error) ->
    error? and -1 isnt error.message?.indexOf '
      PHP Fatal error:  require_once(): Failed opening required
    '

  showMessage: (type, message) ->
    @atom.notifications["add#{type}"] message
