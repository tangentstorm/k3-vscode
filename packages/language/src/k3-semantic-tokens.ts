import { AbstractSemanticTokenProvider, SemanticTokenAcceptor } from 'langium/lsp';
import { AstNode, CstNode, isLeafCstNode, isCompositeCstNode } from 'langium';
import { isKAssign, isKIdent, KLvalue } from 'k3-language';

export class K3SemanticTokens extends AbstractSemanticTokenProvider {

  protected override highlightElement(el: AstNode, accept: SemanticTokenAcceptor): void | undefined | 'prune' {
    const cst: CstNode | undefined = (el as any).$cstNode;
    if (!cst) return;

    const visit = (n: CstNode) => {
      if (isLeafCstNode(n) && n.tokenType) {
        switch (n.tokenType.name) {
          case 'NUMBER': accept({ cst: n, type: 'number' }); break;
          case 'NUMCOLON': accept({ cst: n, type: 'operator' }); break;
          case 'STRING': accept({ cst: n, type: 'string' }); break;
          case 'PRIM':
          case 'PRIMCOLON':
          case 'ADVERB': accept({ cst: n, type: 'operator' }); break;
          case 'SYMBOL': accept({ cst: n, type: 'variable', modifier: ['readonly'] }); break;
          case 'COMMENT': accept({ cst: n, type: 'comment' }); break;
          default: } }
      else if (isCompositeCstNode(n)) { for (const c of n.content) visit(c) }};

      if (isKAssign(el)) {
        const lv : KLvalue | undefined = el.lvalue;
        if (lv) accept({node:lv, keyword:'ident', type:'variable', modifier:'declaration'})}
      else if (isKIdent(el)) {
        accept({ node:el, keyword:'ident', type:'variable' })}

    visit(cst)}}
