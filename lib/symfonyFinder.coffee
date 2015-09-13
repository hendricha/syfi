module.exports = class SymfonyFinder
  constructor: (@exec, @atom) ->

  findSelection: ->
    editor = @atom.workspace.paneContainer.activePane.activeItem
    folder = @atom.project.rootDirectories[0].path
    @exec "#{__dirname}/../cli '#{editor.getSelectedText()}'",
      { cwd: folder }, @openResult

  openResult: (error, stdout, stderr) =>
    if error? or stderr?.length
      throw new Error "
        syfi exec error:
        #{error?.message or ''}
        #{stderr?.toString() or ''}
      "
    @atom.workspace.open stdout.toString().trim()
