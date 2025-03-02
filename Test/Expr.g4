grammar Expr;  // Define the grammar name as 'Expr'


// --- Parser Members (Helper Code for Temporary Variables) ---
@parser::members {
tmp_count = 0
def new_tmp(self):
    self.tmp_count += 1
    return 't' + str(self.tmp_count)
}

// --- Parsing Rules: Program Structure ---
program:  (expr NEWLINE)* ;  // program consists of zero or more expressions, each followed by a newline.

expr returns [val = str()]
    :   e1=expr op=('*'|'/') e2=expr
        {$val = self.new_tmp()}
        {print(f'{$val} = {$e1.val} {$op.text} {$e2.val}')}
    |   e1=expr op=('+'|'-') e2=expr
        {$val = self.new_tmp()}
        {print(f'{$val} = {$e1.val} {$op.text} {$e2.val}')}
    |   n=INT {$val = $n.text}  // If the expression is just a number (INT), return the number as is
    |   '(' e=expr ')' {$val = $e.val}
    ;

// --- Lexer Rules (Define Tokens) ---
NEWLINE : [\r\n]+ ;
INT     : [0-9]+ ;
WS      : [ \t] -> skip;