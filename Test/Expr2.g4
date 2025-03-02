grammar Expr2;  // Grammar name: Expr2

@parser::members {
tmp_count = 0
def new_tmp(self):
    self.tmp_count += 1
    return 't' + str(self.tmp_count)

def expr_operation(self, e1_val, op_text, e2_val):
    val = self.new_tmp()
    print(f'{val} = {e1_val} {op_text} {e2_val}')
    return val
}

program:  (expr NEWLINE)* ;

expr returns [val = str()]
    :   e1=expr op=('*'|'/') e2=expr {$val = self.expr_operation($e1.val, $op.text, $e2.val)}
    |   e1=expr op=('+'|'-') e2=expr {$val = self.expr_operation($e1.val, $op.text, $e2.val)}
    |   n=INT {$val = $n.text}
    |   '(' e=expr ')' {$val = $e.val}
    ;


NEWLINE : [\r\n]+ ;
INT     : [0-9]+ ;
WS      :[ \t] -> skip;