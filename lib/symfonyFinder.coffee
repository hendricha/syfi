module.exports = class SymfonyFinder
  constructor: (@exec, @atom) ->

  findSelection: ->
    editor = @atom.workspace.paneContainer.activePane.activeItem
    folder = @atom.project.rootDirectories[0].path
    @exec "#{__dirname}/../syfi-cli '#{editor.getSelectedText()}'",
      { cwd: folder }, @openResult

  openResult: (error, stdout, stderr) =>
    if error? or stderr?.length
      throw new Error "
        syfi exec error:
        #{error?.message or ''}
        #{stderr?.toString() or ''}
      "

    return @showMessage 'Selction could not be found' if stdout.toString().trim() is ''
    @atom.workspace.open stdout.toString().trim()

  showMessage: (message) ->
    @atom.notifications.addInfo 'Could not find selection'
