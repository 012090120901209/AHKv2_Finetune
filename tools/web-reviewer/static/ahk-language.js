/**
 * AutoHotkey v2 Language Definition for Monaco Editor
 * Based on THQBY's vscode-autohotkey2-lsp TextMate grammar
 */

const AHK_LANGUAGE_ID = 'autohotkey2';
const AHK_THEME_NAME = 'ahk-dark';

// Theme colors matching VS Code's Dark+ with AHK LSP scopes
const AHK_THEME_DATA = {
  base: 'vs-dark',
  inherit: true,
  rules: [
    // Comments - green
    { token: 'comment', foreground: '6A9955' },

    // Keywords - purple/pink
    { token: 'keyword', foreground: 'C586C0' },
    { token: 'keyword.control', foreground: 'C586C0' },
    { token: 'storage.type', foreground: 'C586C0' },

    // Directives - purple bold
    { token: 'keyword.directive', foreground: 'C586C0', fontStyle: 'bold' },

    // Class/Type names - teal/cyan
    { token: 'entity.name.type', foreground: '4EC9B0' },
    { token: 'support.class', foreground: '4EC9B0' },
    { token: 'type', foreground: '4EC9B0' },

    // Function names - yellow
    { token: 'entity.name.function', foreground: 'DCDCAA' },
    { token: 'support.function', foreground: 'DCDCAA' },

    // Variables - light blue
    { token: 'variable', foreground: '9CDCFE' },
    { token: 'variable.property', foreground: '9CDCFE' },
    { token: 'identifier', foreground: '9CDCFE' },

    // Special variables (this, super, A_*) - blue
    { token: 'variable.language', foreground: '569CD6' },

    // Constants (true, false) - blue
    { token: 'constant', foreground: '569CD6' },

    // Strings - orange
    { token: 'string', foreground: 'CE9178' },
    { token: 'string.escape', foreground: 'D7BA7D' },

    // Numbers - light green
    { token: 'number', foreground: 'B5CEA8' },

    // Hotkeys/Hotstrings - gold
    { token: 'keyword.keys', foreground: 'D7BA7D' },
    { token: 'label', foreground: 'D7BA7D' },

    // Operators and delimiters - light gray
    { token: 'delimiter', foreground: 'D4D4D4' },
    { token: 'operator', foreground: 'D4D4D4' },
  ],
  colors: {
    'editor.background': '#1e1e1e',
    'editor.foreground': '#d4d4d4',
  },
};

// Built-in functions from LSP (as array for Monarch cases)
const BUILTIN_FUNCTIONS = [
  'abs', 'acos', 'asin', 'atan', 'blockinput', 'callbackcreate', 'callbackfree', 'caretgetpos', 'ceil', 'chr', 'click', 'clipwait', 'comcall', 'comobjactive', 'comobjconnect', 'comobjflags', 'comobjfromptr', 'comobjget', 'comobjquery', 'comobjtype', 'comobjvalue', 'controladditem', 'controlchooseindex', 'controlchoosestring', 'controlclick', 'controldeleteitem', 'controlfinditem', 'controlfocus', 'controlgetchecked', 'controlgetchoice', 'controlgetclassnn', 'controlgetenabled', 'controlgetexstyle', 'controlgetfocus', 'controlgethwnd', 'controlgetindex', 'controlgetitems', 'controlgetpos', 'controlgetstyle', 'controlgettext', 'controlgetvisible', 'controlhide', 'controlhidedropdown', 'controlmove', 'controlsend', 'controlsendtext', 'controlsetchecked', 'controlsetenabled', 'controlsetexstyle', 'controlsetstyle', 'controlsettext', 'controlshow', 'controlshowdropdown', 'coordmode', 'cos', 'critical', 'dateadd', 'datediff', 'detecthiddentext', 'detecthiddenwindows', 'dircopy', 'dircreate', 'dirdelete', 'direxist', 'dirmove', 'dirselect', 'dllcall', 'download', 'driveeject', 'drivegetcapacity', 'drivegetfilesystem', 'drivegetlabel', 'drivegetlist', 'drivegetserial', 'drivegetspacefree', 'drivegetstatus', 'drivegetstatuscd', 'drivegettype', 'drivelock', 'driveretract', 'drivesetlabel', 'driveunlock', 'edit', 'editgetcurrentcol', 'editgetcurrentline', 'editgetline', 'editgetlinecount', 'editgetselectedtext', 'editpaste', 'envget', 'envset', 'exit', 'exitapp', 'exp', 'fileappend', 'filecopy', 'filecreateshortcut', 'filedelete', 'fileencoding', 'fileexist', 'filegetattrib', 'filegetshortcut', 'filegetsize', 'filegettime', 'filegetversion', 'fileinstall', 'filemove', 'fileopen', 'fileread', 'filerecycle', 'filerecycleempty', 'fileselect', 'filesetattrib', 'filesettime', 'floor', 'format', 'formattime', 'getkeyname', 'getkeysc', 'getkeystate', 'getkeyvk', 'getmethod', 'groupactivate', 'groupadd', 'groupclose', 'groupdeactivate', 'guictrlfromhwnd', 'guifromhwnd', 'hasbase', 'hasmethod', 'hasprop', 'hotif', 'hotifwinactive', 'hotifwinexist', 'hotifwinnotactive', 'hotifwinnotexist', 'hotkey', 'hotstring', 'il_add', 'il_create', 'il_destroy', 'imagesearch', 'inidelete', 'iniread', 'iniwrite', 'inputbox', 'installkeybdhook', 'installmousehook', 'instr', 'isalnum', 'isalpha', 'isdigit', 'isfloat', 'isinteger', 'islabel', 'islower', 'isnumber', 'isobject', 'isset', 'issetref', 'isspace', 'istime', 'isupper', 'isxdigit', 'keyhistory', 'keywait', 'listhotkeys', 'listlines', 'listvars', 'listviewgetcontent', 'ln', 'loadpicture', 'log', 'ltrim', 'max', 'menufromhandle', 'menuselect', 'min', 'mod', 'monitorget', 'monitorgetcount', 'monitorgetname', 'monitorgetprimary', 'monitorgetworkarea', 'mouseclick', 'mouseclickdrag', 'mousegetpos', 'mousemove', 'msgbox', 'numget', 'numput', 'objaddref', 'objbindmethod', 'objfromptr', 'objfromptraddref', 'objgetbase', 'objgetcapacity', 'objhasownprop', 'objownpropcount', 'objownprops', 'objptr', 'objptraddref', 'objrelease', 'objsetbase', 'objsetcapacity', 'onclipboardchange', 'onerror', 'onexit', 'onmessage', 'ord', 'outputdebug', 'pause', 'persistent', 'pixelgetcolor', 'pixelsearch', 'postmessage', 'processclose', 'processexist', 'processgetname', 'processgetparent', 'processgetpath', 'processsetpriority', 'processwait', 'processwaitclose', 'random', 'regdelete', 'regdeletekey', 'regexmatch', 'regexreplace', 'regread', 'regwrite', 'reload', 'round', 'rtrim', 'run', 'runas', 'runwait', 'send', 'sendevent', 'sendinput', 'sendlevel', 'sendmessage', 'sendmode', 'sendplay', 'sendtext', 'setcapslockstate', 'setcontroldelay', 'setdefaultmousespeed', 'setkeydelay', 'setmousedelay', 'setnumlockstate', 'setregview', 'setscrolllockstate', 'setstorecapslockmode', 'settimer', 'settitlematchmode', 'setwindelay', 'setworkingdir', 'shutdown', 'sin', 'sleep', 'sort', 'soundbeep', 'soundgetinterface', 'soundgetmute', 'soundgetname', 'soundgetvolume', 'soundplay', 'soundsetmute', 'soundsetvolume', 'splitpath', 'sqrt', 'statusbargettext', 'statusbarwait', 'strcompare', 'strget', 'strlen', 'strlower', 'strptr', 'strput', 'strreplace', 'strsplit', 'strtitle', 'strupper', 'substr', 'suspend', 'sysget', 'sysgetipaddresses', 'tan', 'thread', 'tooltip', 'trayseticon', 'traytip', 'trim', 'type', 'varsetstrcapacity', 'vercompare', 'winactivate', 'winactivatebottom', 'winactive', 'winclose', 'winexist', 'wingetclass', 'wingetclientpos', 'wingetcontrols', 'wingetcontrolshwnd', 'wingetcount', 'wingetexstyle', 'wingetid', 'wingetidlast', 'wingetlist', 'wingetminmax', 'wingetpid', 'wingetpos', 'wingetprocessname', 'wingetprocesspath', 'wingetstyle', 'wingettext', 'wingettitle', 'wingettranscolor', 'wingettransparent', 'winhide', 'winkill', 'winmaximize', 'winminimize', 'winminimizeall', 'winminimizeallundo', 'winmove', 'winmovebottom', 'winmovetop', 'winredraw', 'winrestore', 'winsetalwaysontop', 'winsetenabled', 'winsetexstyle', 'winsetregion', 'winsetstyle', 'winsettitle', 'winsettranscolor', 'winsettransparent', 'winshow', 'winwait', 'winwaitactive', 'winwaitclose', 'winwaitnotactive'
];

// Built-in classes from LSP (lowercase for case-insensitive matching)
const BUILTIN_CLASSES = [
  'any', 'array', 'boundfunc', 'buffer', 'class', 'clipboardall', 'closure', 'comobjarray', 'comobject', 'comvalue', 'comvalueref', 'enumerator', 'error', 'file', 'float', 'func', 'gui', 'indexerror', 'inputhook', 'integer', 'keyerror', 'map', 'membererror', 'memoryerror', 'menu', 'menubar', 'methoderror', 'number', 'object', 'oserror', 'primitive', 'propertyerror', 'regexmatchinfo', 'string', 'targeterror', 'timeouterror', 'typeerror', 'valueerror', 'varref', 'zerodivisionerror'
];

// Keywords (lowercase)
const KEYWORDS = [
  'if', 'else', 'while', 'loop', 'for', 'in', 'try', 'catch', 'finally', 'throw', 'return', 'break', 'continue', 'goto', 'global', 'local', 'static', 'class', 'extends', 'new', 'and', 'or', 'not', 'is', 'contains', 'isset', 'as', 'until', 'switch', 'case', 'default'
];

const AHK_LANGUAGE_DEF = {
  defaultToken: 'identifier',
  ignoreCase: true,

  // Arrays for case matching
  builtinFunctions: BUILTIN_FUNCTIONS,
  builtinClasses: BUILTIN_CLASSES,
  keywords: KEYWORDS,

  tokenizer: {
    root: [
      // Whitespace
      [/[ \t\r\n]+/, 'white'],

      // Directives at start of line: #Requires, #Include, etc.
      [/^\s*#[a-zA-Z_]\w*\b/, 'keyword.directive'],

      // Hotstring definition: :options:trigger::replacement
      [/^:[^:]*:[^:]+::/, 'keyword.keys'],

      // Hotkey definition: ^!a::, LButton::, etc.
      [/^[#!^+<>*~$]*[a-zA-Z0-9_]+::/, 'keyword.keys'],

      // Labels: MyLabel:
      [/^[a-zA-Z_]\w*:(?!=)/, 'label'],

      // Block comments
      [/\/\*/, 'comment', '@blockComment'],

      // Line comments
      [/;.*$/, 'comment'],

      // Strings
      [/"/, 'string', '@stringDouble'],
      [/'/, 'string', '@stringSingle'],

      // Numbers
      [/0[xX][0-9a-fA-F]+/, 'number'],
      [/\d+\.?\d*([eE][\-+]?\d+)?/, 'number'],
      [/\.\d+([eE][\-+]?\d+)?/, 'number'],

      // Built-in variables: A_ScriptDir, A_Now, etc.
      [/\bA_[a-zA-Z_]\w*\b/, 'variable.language'],

      // this and super
      [/\b(this|super)\b/, 'variable.language'],

      // true, false, unset
      [/\b(true|false|unset)\b/, 'constant'],

      // Class definition: class ClassName (with optional extends)
      [/\b(class)(\s+)([a-zA-Z_]\w*)/, ['storage.type', 'white', 'entity.name.type']],

      // Extends: extends ClassName
      [/\b(extends)(\s+)([a-zA-Z_]\w*)/, ['keyword', 'white', 'entity.name.type']],

      // new ClassName(
      [/\b(new)(\s+)([a-zA-Z_]\w*)/, ['keyword', 'white', 'entity.name.type']],

      // Method/property access: .name( or .name
      [/(\.)([a-zA-Z_]\w*)(\s*)(\()/, ['delimiter', 'entity.name.function', 'white', 'delimiter']],
      [/(\.)([a-zA-Z_]\w*)/, ['delimiter', 'variable.property']],

      // Function call: name(
      [/([a-zA-Z_]\w*)(\s*)(\()/, [
        { cases: {
            '@builtinFunctions': 'support.function',
            '@builtinClasses': 'support.class',
            '@default': 'entity.name.function'
        }},
        'white',
        'delimiter'
      ]],

      // Standalone identifiers (not followed by parenthesis)
      [/[a-zA-Z_]\w*/, {
        cases: {
          '@keywords': 'keyword',
          '@builtinClasses': 'support.class',
          '@default': 'identifier'
        }
      }],

      // Fat arrow
      [/=>/, 'keyword'],

      // Assignment operators
      [/:=|\.=|\+=|-=|\*=|\/=|\/\/=|\|=|&=|\^=|>>=|<<=/, 'operator'],

      // Comparison and logical
      [/==|!=|<>|<=|>=|&&|\|\||\?\?|~=/, 'operator'],

      // Other operators
      [/[+\-*\/%&|^~!<>?:]/, 'operator'],

      // Brackets
      [/[{}()\[\]]/, 'delimiter'],

      // Comma
      [/[,]/, 'delimiter'],
    ],

    blockComment: [
      [/[^\/*]+/, 'comment'],
      [/\*\//, 'comment', '@pop'],
      [/[\/*]/, 'comment']
    ],

    stringDouble: [
      [/`[nrtbfv0"'`%;]/, 'string.escape'],
      [/[^"`]+/, 'string'],
      [/"/, 'string', '@pop']
    ],

    stringSingle: [
      [/`[nrtbfv0"'`%;]/, 'string.escape'],
      [/[^'`]+/, 'string'],
      [/'/, 'string', '@pop']
    ],
  }
};

// Register the language with Monaco
function registerAHKLanguage(monaco) {
  // Register the language ID
  monaco.languages.register({
    id: AHK_LANGUAGE_ID,
    extensions: ['.ahk', '.ah2', '.ahk2'],
    aliases: ['AutoHotkey', 'autohotkey', 'ahk', 'ahk2']
  });

  // Define the theme
  monaco.editor.defineTheme(AHK_THEME_NAME, AHK_THEME_DATA);

  // Set the monarch tokenizer
  monaco.languages.setMonarchTokensProvider(AHK_LANGUAGE_ID, AHK_LANGUAGE_DEF);

  // Set language configuration
  monaco.languages.setLanguageConfiguration(AHK_LANGUAGE_ID, {
    comments: {
      lineComment: ';',
      blockComment: ['/*', '*/']
    },
    brackets: [
      ['{', '}'],
      ['[', ']'],
      ['(', ')']
    ],
    autoClosingPairs: [
      { open: '{', close: '}' },
      { open: '[', close: ']' },
      { open: '(', close: ')' },
      { open: '"', close: '"' },
      { open: "'", close: "'" }
    ],
    surroundingPairs: [
      { open: '{', close: '}' },
      { open: '[', close: ']' },
      { open: '(', close: ')' },
      { open: '"', close: '"' },
      { open: "'", close: "'" }
    ]
  });

  console.log('AHK language registered with Monaco');
}

// Initialize Monaco Editor
function initMonaco() {
  return new Promise((resolve, reject) => {
    // Configure the Monaco loader
    require.config({
      paths: {
        'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs'
      }
    });

    // Load Monaco
    require(['vs/editor/editor.main'], function(monaco) {
      // Register AHK language
      registerAHKLanguage(monaco);
      resolve(monaco);
    }, reject);
  });
}

// Export for use
window.AHK_LANGUAGE_ID = AHK_LANGUAGE_ID;
window.AHK_THEME_NAME = AHK_THEME_NAME;
window.registerAHKLanguage = registerAHKLanguage;
window.initMonaco = initMonaco;
