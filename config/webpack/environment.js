const { environment } = require('@rails/webpacker')
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');

environment.plugins.prepend(
  'MonacoWebpackPlugin',
  new MonacoWebpackPlugin({
    languages: ['ruby'],
    features: ['accessibilityHelp', '!anchorSelect', '!bracketMatching', '!caretOperations', '!clipboard', '!codeAction', '!codelens', '!colorDetector', 'comment', '!contextmenu', '!coreCommands', '!cursorUndo', '!dnd', '!find', '!folding', '!fontZoom', '!format', '!gotoError', '!gotoLine', '!gotoSymbol', '!hover', 'iPadShowKeyboard', '!inPlaceReplace', 'indentation', '!inspectTokens', '!linesOperations', '!links', '!multicursor', '!onTypeRename', '!parameterHints', '!quickCommand', '!quickHelp', '!quickOutline', '!referenceSearch', '!rename', '!smartSelect', '!snippets', '!suggest', '!toggleHighContrast', '!toggleTabFocusMode', '!transpose', '!unusualLineTerminators', '!viewportSemanticTokens', '!wordHighlighter', '!wordOperations', '!wordPartOperations']
  })
)

module.exports = environment
