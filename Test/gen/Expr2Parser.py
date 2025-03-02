# Generated from D:/Projects/CompilerProject/Test/Expr2.g4 by ANTLR 4.13.2
# encoding: utf-8
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
	from typing import TextIO
else:
	from typing.io import TextIO

def serializedATN():
    return [
        4,1,9,38,2,0,7,0,2,1,7,1,1,0,1,0,1,0,5,0,8,8,0,10,0,12,0,11,9,0,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,21,8,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,5,1,33,8,1,10,1,12,1,36,9,1,1,1,0,1,2,2,0,2,0,
        2,1,0,1,2,1,0,3,4,39,0,9,1,0,0,0,2,20,1,0,0,0,4,5,3,2,1,0,5,6,5,
        7,0,0,6,8,1,0,0,0,7,4,1,0,0,0,8,11,1,0,0,0,9,7,1,0,0,0,9,10,1,0,
        0,0,10,1,1,0,0,0,11,9,1,0,0,0,12,13,6,1,-1,0,13,14,5,8,0,0,14,21,
        6,1,-1,0,15,16,5,5,0,0,16,17,3,2,1,0,17,18,5,6,0,0,18,19,6,1,-1,
        0,19,21,1,0,0,0,20,12,1,0,0,0,20,15,1,0,0,0,21,34,1,0,0,0,22,23,
        10,4,0,0,23,24,7,0,0,0,24,25,3,2,1,5,25,26,6,1,-1,0,26,33,1,0,0,
        0,27,28,10,3,0,0,28,29,7,1,0,0,29,30,3,2,1,4,30,31,6,1,-1,0,31,33,
        1,0,0,0,32,22,1,0,0,0,32,27,1,0,0,0,33,36,1,0,0,0,34,32,1,0,0,0,
        34,35,1,0,0,0,35,3,1,0,0,0,36,34,1,0,0,0,4,9,20,32,34
    ]

class Expr2Parser ( Parser ):

    grammarFileName = "Expr2.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'*'", "'/'", "'+'", "'-'", "'('", "')'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "NEWLINE", 
                      "INT", "WS" ]

    RULE_program = 0
    RULE_expr = 1

    ruleNames =  [ "program", "expr" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    T__2=3
    T__3=4
    T__4=5
    T__5=6
    NEWLINE=7
    INT=8
    WS=9

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.2")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None



    tmp_count = 0
    def new_tmp(self):
        self.tmp_count += 1
        return 't' + str(self.tmp_count)

    def expr_operation(self, e1_val, op_text, e2_val):
        val = self.new_tmp()
        print(f'{val} = {e1_val} {op_text} {e2_val}')
        return val



    class ProgramContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def expr(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(Expr2Parser.ExprContext)
            else:
                return self.getTypedRuleContext(Expr2Parser.ExprContext,i)


        def NEWLINE(self, i:int=None):
            if i is None:
                return self.getTokens(Expr2Parser.NEWLINE)
            else:
                return self.getToken(Expr2Parser.NEWLINE, i)

        def getRuleIndex(self):
            return Expr2Parser.RULE_program




    def program(self):

        localctx = Expr2Parser.ProgramContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_program)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 9
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==5 or _la==8:
                self.state = 4
                self.expr(0)
                self.state = 5
                self.match(Expr2Parser.NEWLINE)
                self.state = 11
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ExprContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.val = str()
            self.e1 = None # ExprContext
            self.n = None # Token
            self.e = None # ExprContext
            self.op = None # Token
            self.e2 = None # ExprContext

        def INT(self):
            return self.getToken(Expr2Parser.INT, 0)

        def expr(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(Expr2Parser.ExprContext)
            else:
                return self.getTypedRuleContext(Expr2Parser.ExprContext,i)


        def getRuleIndex(self):
            return Expr2Parser.RULE_expr



    def expr(self, _p:int=0):
        _parentctx = self._ctx
        _parentState = self.state
        localctx = Expr2Parser.ExprContext(self, self._ctx, _parentState)
        _prevctx = localctx
        _startState = 2
        self.enterRecursionRule(localctx, 2, self.RULE_expr, _p)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 20
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [8]:
                self.state = 13
                localctx.n = self.match(Expr2Parser.INT)
                localctx.val = (None if localctx.n is None else localctx.n.text)
                pass
            elif token in [5]:
                self.state = 15
                self.match(Expr2Parser.T__4)
                self.state = 16
                localctx.e = self.expr(0)
                self.state = 17
                self.match(Expr2Parser.T__5)
                localctx.val = localctx.e.val
                pass
            else:
                raise NoViableAltException(self)

            self._ctx.stop = self._input.LT(-1)
            self.state = 34
            self._errHandler.sync(self)
            _alt = self._interp.adaptivePredict(self._input,3,self._ctx)
            while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                if _alt==1:
                    if self._parseListeners is not None:
                        self.triggerExitRuleEvent()
                    _prevctx = localctx
                    self.state = 32
                    self._errHandler.sync(self)
                    la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
                    if la_ == 1:
                        localctx = Expr2Parser.ExprContext(self, _parentctx, _parentState)
                        localctx.e1 = _prevctx
                        self.pushNewRecursionContext(localctx, _startState, self.RULE_expr)
                        self.state = 22
                        if not self.precpred(self._ctx, 4):
                            from antlr4.error.Errors import FailedPredicateException
                            raise FailedPredicateException(self, "self.precpred(self._ctx, 4)")
                        self.state = 23
                        localctx.op = self._input.LT(1)
                        _la = self._input.LA(1)
                        if not(_la==1 or _la==2):
                            localctx.op = self._errHandler.recoverInline(self)
                        else:
                            self._errHandler.reportMatch(self)
                            self.consume()
                        self.state = 24
                        localctx.e2 = self.expr(5)
                        localctx.val = self.expr_operation(localctx.e1.val, (None if localctx.op is None else localctx.op.text), localctx.e2.val)
                        pass

                    elif la_ == 2:
                        localctx = Expr2Parser.ExprContext(self, _parentctx, _parentState)
                        localctx.e1 = _prevctx
                        self.pushNewRecursionContext(localctx, _startState, self.RULE_expr)
                        self.state = 27
                        if not self.precpred(self._ctx, 3):
                            from antlr4.error.Errors import FailedPredicateException
                            raise FailedPredicateException(self, "self.precpred(self._ctx, 3)")
                        self.state = 28
                        localctx.op = self._input.LT(1)
                        _la = self._input.LA(1)
                        if not(_la==3 or _la==4):
                            localctx.op = self._errHandler.recoverInline(self)
                        else:
                            self._errHandler.reportMatch(self)
                            self.consume()
                        self.state = 29
                        localctx.e2 = self.expr(4)
                        localctx.val = self.expr_operation(localctx.e1.val, (None if localctx.op is None else localctx.op.text), localctx.e2.val)
                        pass

             
                self.state = 36
                self._errHandler.sync(self)
                _alt = self._interp.adaptivePredict(self._input,3,self._ctx)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.unrollRecursionContexts(_parentctx)
        return localctx



    def sempred(self, localctx:RuleContext, ruleIndex:int, predIndex:int):
        if self._predicates == None:
            self._predicates = dict()
        self._predicates[1] = self.expr_sempred
        pred = self._predicates.get(ruleIndex, None)
        if pred is None:
            raise Exception("No predicate with index:" + str(ruleIndex))
        else:
            return pred(localctx, predIndex)

    def expr_sempred(self, localctx:ExprContext, predIndex:int):
            if predIndex == 0:
                return self.precpred(self._ctx, 4)
         

            if predIndex == 1:
                return self.precpred(self._ctx, 3)
         




