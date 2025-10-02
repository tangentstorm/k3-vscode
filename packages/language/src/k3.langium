grammar K3

entry KCode:
    lines+=KLine* stmts=KStmts? trailer=(KEndnote | KCommand | KComment)?;

KEndnote: x=ENDNOTE ;

KComment: x=COMMENT ;

KCommand: x=COMMAND ;

KLine
  : comment=KComment NL
  | command=KCommand NL
  | stmts=KStmts? comment=KComment? NL
  | NL;

// Statements: either one-or-more expressions separated by semicolons,
// or one-or-more standalone semicolons (to preserve k3's empty exprs)
KStmts
  : exprs+=KExpr (SEMI exprs+=KExpr?)*
  | semicolons+=SEMI+;

KExpr
  : ':'
  | value=KReturn
  | value=KChain;

KChain: atoms+=KChainAtom+ primColon=PRIMCOLON?;
KChainAtom:
      x=KCase
    | x=KFlow
    | x=KAssign
    | x=KFunc
    | x=KCall
    | x=KNest
    | x=KLvalue
    | x=PRIM
    | x=PRIMCOLON
    | x=NUMCOLON
    | x=ADVERB
    | x=NUMBER
    | x=STRING
    | X=SYMBOL;

KCase
  : ':[' ']'
  | ':[' block=KBlock ']';

KFlow
  : kind=('if[' | 'while[' | 'do[') ']'
  | kind=('if[' | 'while[' | 'do[') block=KBlock ']';

KNest: '(' ')'
     | '(' block=KBlock ')';

// Block: at least one line (which itself consumes NL) with optional trailing stmts,
// or just stmts (which must consume something due to KStmts definition above)
KBlock: lines+=KLine (NL* lines+=KLine)* stmts=KStmts?
      | stmts=KStmts;

KAssign: lvalue=KLvalue calls+=KCall* op=(':' | PRIMCOLON) rhs=KExpr;

KLvalue: ident=KIdent call=KCall?;

KIdent returns string:
    LNAME | GNAME;

KCall:
    '[' ']'
  | '[' block=KBlock ']';

Fsig:
    '[' name=LNAME? (SEMI more+=LNAME)* ']';

KFunc :
    '{' fsig=Fsig? block=KBlock '}'
  | '{' fsig=Fsig? '}';

KReturn: ':' expr=KExpr;

// Lexer

hidden terminal WS: /[ \t\f]+/;
terminal NL: /\r?\n/;
terminal SEMI: /;/;

// Comments and commands (approximate context-sensitive behavior)
terminal COMMENT: /\/(?!:)[^\r\n]*/;
terminal COMMAND: /\\(?!:)[^\r\n]*/;

// Endnote: backslash, optional spaces, newline, then rest of input
terminal ENDNOTE: /\\[ \t]*\r?\n[\s\S]*/;

// Adverbs: ', '/, '/:, '\, '\:
terminal ADVERB: /'(?:\:)?|\/(?:\:)?|\\(?:\:)?/;

// Primitives and special colon-forms
terminal PRIMCOLON: /(?:[_+\-*%!&|<>=~,^#$?@.]|:):/;
terminal PRIM: /[_+\-*%!&|<>=~,^#$?@.]+/;

// Numbers and strings
terminal NUMCOLON: /[0-9]+:(?::)?/;
terminal NUMBER returns number: /-?[0-9]+(?:\.[0-9]*)?/;
terminal STRING: /"(\\.|[^"\\])*"/;

// Names
terminal LNAME: /_?[A-Za-z][A-Za-z0-9_]*(?:\._?[A-Za-z][A-Za-z0-9_]*)*/;
terminal GNAME: /\.(?:_?[A-Za-z][A-Za-z0-9_]*)(?:\._?[A-Za-z][A-Za-z0-9_]*)*/;

// Symbols (backtick + lname | gname | string, optional)
terminal SYMBOL: /`(?:_?[A-Za-z][A-Za-z0-9_]*(?:\._?[A-Za-z][A-Za-z0-9_]*)*|\.(?:_?[A-Za-z][A-Za-z0-9_]*)(?:\._?[A-Za-z][A-Za-z0-9_]*)*|"(\\.|[^"\\])*")?/;
