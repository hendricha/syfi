path = require 'path'
SymfonyFinder = require '../lib/symfonyFinder'

describe "SymfonyFinder", ->
  [atomMock, editorMock, childProcessMock, finder] = []

  beforeEach ->
    editorMock = getSelectedText: ->
    atomMock =
      project: rootDirectories: [ path: '/home/foo/bar' ]
      workspace:
        paneContainer: activePane: activeItem: editorMock
        open: ->
      notifications: addInfo: ->
    childProcessMock = exec: (cmd, options, callback) ->
        callback(null, '/home/foo/bar/someFile.php', '')

    spyOn(editorMock, 'getSelectedText')
      .andReturn 'foo'
    spyOn atomMock.workspace, 'open'
    spyOn atomMock.notifications, 'addInfo'

  describe "findSelection", ->
    it "should attempt to find current selected text with the cli command", ->
      spyOn(childProcessMock, 'exec').andCallThrough()
      do (new SymfonyFinder childProcessMock.exec, atomMock).findSelection

      expect(editorMock.getSelectedText)
        .toHaveBeenCalled()

      expect(childProcessMock.exec.mostRecentCall.args[0])
        .toEqual "#{path.normalize(__dirname + '/..')}/lib/../syfi-cli 'foo'"

      expect(childProcessMock.exec.mostRecentCall.args[1])
        .toEqual cwd: '/home/foo/bar'

      expect(typeof childProcessMock.exec.mostRecentCall.args[2])
        .toEqual 'function'

      expect(atomMock.workspace.open)
        .toHaveBeenCalledWith '/home/foo/bar/someFile.php'

    it "should throw an error message if exec had some kind of error", ->
      childProcessMock.exec = (cmd, options, callback) ->
        callback new Error 'something'
      finder = new SymfonyFinder childProcessMock.exec, atomMock

      expect(-> do finder.findSelection).toThrow()

      childProcessMock.exec = (cmd, options, callback) ->
        callback null, 'stdout', 'stderr'
      finder = new SymfonyFinder childProcessMock.exec, atomMock

      expect(-> do finder.findSelection).toThrow()

    it "should post a message if no string was returned", ->
      childProcessMock.exec = (cmd, options, callback) ->
        callback null, ''

      do (new SymfonyFinder childProcessMock.exec, atomMock).findSelection

      expect(atomMock.workspace.open).not.toHaveBeenCalled()
      expect(atomMock.notifications.addInfo).toHaveBeenCalled()
