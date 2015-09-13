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
    childProcessMock = exec: (cmd, options, callback) ->
        callback(null, '/home/foo/bar/someFile.php', '')

    spyOn(editorMock, 'getSelectedText')
      .andReturn 'foo'
    spyOn atomMock.workspace, 'open'
    spyOn(childProcessMock, 'exec').andCallThrough()

    finder = new SymfonyFinder childProcessMock.exec, atomMock

  describe "findSelection", ->
    it "should attempt to find current selected text with the cli command", ->
      do finder.findSelection
      expect(editorMock.getSelectedText)
        .toHaveBeenCalled()
      expect(childProcessMock.exec.mostRecentCall.args[0])
        .toEqual "#{path.normalize(__dirname + '/..')}/lib/../syfi-cli 'foo'"
      expect(childProcessMock.exec.mostRecentCall.args[1])
        .toEqual cwd: '/home/foo/bar', ->
      expect(typeof childProcessMock.exec.mostRecentCall.args[2])
        .toEqual 'function'
      expect(atomMock.workspace.open)
        .toHaveBeenCalledWith '/home/foo/bar/someFile.php'

    it "should throw an error message if exec had some kind of error", ->
      childProcessMock.exec = (cmd, options, callback) ->
        callback new Error 'something'
      expect(finder.findSelection).toThrow()

      childProcessMock.exec = (cmd, options, callback) ->
        callback null, 'stdout', 'stderr'
      expect(finder.findSelection).toThrow()
