/*
 [The "BSD licence"]
 Copyright (c) 2013 Terence Parr, Sam Harwell
 Copyright (c) 2017 Ivan Kochurkin (upgrade to Java 8)
 Copyright (c) 2021 Michał Lorek (upgrade to Java 11)
 Copyright (c) 2022 Michał Lorek (upgrade to Java 17)
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

parser grammar JavaParser;

options { tokenVocab=JavaLexer; }

@parser::members{
tmp_count = 0
def new_temp(self):
    self.tmp_count = self.tmp_count + 1
    return 't' + str(self.tmp_count)

label_count = 0
def new_label(self):
    self.label_count = self.label_count + 1
    return 'L' + str(self.label_count)

def expression1(self, postfix, expression_val):
    tmp = self.new_temp()
    val = f'{tmp} = {expression_val}' + '\n'
    if postfix == '++':
        val += f'{expression_val} = {expression_val} + 1'
    else:
        val += f'{expression_val} = {expression_val} - 1'
    return val

def expression2(self, prefix, expression_val):
    tmp = self.new_temp()
    if postfix == '++':
        val = f'{expression_val} = {expression_val} + 1' + '\n'
    else:
        val = f'{expression_val} = {expression_val} - 1' + '\n'
    val += f'{tmp} = {expression_val}'
    return val

def expression3(self, e1_val, e2_val, bop):
    if bop == '=':
        return f'{e1_val} = {e2_val}'
    return f'{e1_val} = {e1_val} {bop[:-1]} {e2_val}'

def variable_declarator(self, variableDeclaratorIdVal, variableInitializerVal):
    print(f'{variableDeclaratorIdVal} = {variableInitializerVal}')
    return variableDeclaratorIdVal

def if1(self, parExpressionVal):
    tmp = self.new_temp()
    exit_label = self.new_label()
    else_label = self.new_label()
    print(f'{tmp} = {parExpressionVal}')
    print(f'if NOT {tmp} goto {else_label}')
    return else_label, exit_label

def if2(self, elseLabel, exitLabel):
    print(f'goto {exitLabel}')
    print(f'{elseLabel}:')

def if3(self, elseExists, elseLabel):
    if not elseExists:
        print(f'{elseLabel}:')

def while1(self, parExpressionVal):
    tmp = self.new_temp()
    while_label = self.new_label()
    exit_label = self.new_label()
    print(f'{while_label}:')
    print(f'{tmp} = {parExpressionVal}')
    print(f'if NOT {tmp} goto {exit_label}')
    return while_label, exit_label

def while2(self, while_label, exit_label):
    print(f'goto {while_label}')
    print(f'{exit_label}:')

def for1(self, forInitVal, expressionVal):
    for_label = self.new_label()
    exit_label = self.new_label()
    tmp = self.new_temp()
    print(f'{for_label}:')
    print(f'{tmp} = {expressionVal}')
    print(f'if NOT {tmp} goto {exit_label}')
    return for_label, exit_label

def for2(self, update_expression, for_label, exit_label):
    print(f'{update_expression}')
    print(f'goto {for_label}')
    print(f'{exit_label}:')
}

compilationUnit
    : packageDeclaration? importDeclaration* typeDeclaration*
    | moduleDeclaration EOF
    ;

packageDeclaration returns [val = '']
    : annotation* PACKAGE qualifiedName ';'
    ;

importDeclaration
    : IMPORT STATIC? qualifiedName ('.' '*')? ';'
    ;

typeDeclaration
    : classOrInterfaceModifier*
      (classDeclaration | enumDeclaration | interfaceDeclaration | annotationTypeDeclaration | recordDeclaration)
    | ';'
    ;

modifier
    : classOrInterfaceModifier
    | NATIVE
    | SYNCHRONIZED
    | TRANSIENT
    | VOLATILE
    ;

classOrInterfaceModifier
    : annotation
    | PUBLIC
    | PROTECTED
    | PRIVATE
    | STATIC
    | ABSTRACT
    | FINAL    // FINAL for class only -- does not apply to interfaces
    | STRICTFP
    | SEALED // Java17
    | NON_SEALED // Java17
    ;

variableModifier
    : FINAL
    | annotation
    ;

classDeclaration
    : CLASS identifier typeParameters?
      (EXTENDS typeType)?
      (IMPLEMENTS typeList)?
      (PERMITS typeList)? // Java17
      classBody
    ;

typeParameters
    : '<' typeParameter (',' typeParameter)* '>'
    ;

typeParameter
    : annotation* identifier (EXTENDS annotation* typeBound)?
    ;

typeBound
    : typeType ('&' typeType)*
    ;

enumDeclaration
    : ENUM identifier (IMPLEMENTS typeList)? '{' enumConstants? ','? enumBodyDeclarations? '}'
    ;

enumConstants
    : enumConstant (',' enumConstant)*
    ;

enumConstant
    : annotation* identifier arguments? classBody?
    ;

enumBodyDeclarations
    : ';' classBodyDeclaration*
    ;

interfaceDeclaration
    : INTERFACE identifier typeParameters? (EXTENDS typeList)? (PERMITS typeList)? interfaceBody
    ;

classBody
    : '{' classBodyDeclaration* '}'
    ;

interfaceBody
    : '{' interfaceBodyDeclaration* '}'
    ;

classBodyDeclaration
    : ';'
    | STATIC? block
    | modifier* memberDeclaration
    ;

memberDeclaration
    : recordDeclaration //Java17
    | methodDeclaration
    | genericMethodDeclaration
    | fieldDeclaration
    | constructorDeclaration
    | genericConstructorDeclaration
    | interfaceDeclaration
    | annotationTypeDeclaration
    | classDeclaration
    | enumDeclaration
    ;

/* We use rule this even for void methods which cannot have [] after parameters.
   This simplifies grammar and we can consider void to be a type, which
   renders the [] matching as a context-sensitive issue or a semantic check
   for invalid return type after parsing.
 */
methodDeclaration
    : typeTypeOrVoid identifier formalParameters ('[' ']')*
      (THROWS qualifiedNameList)?
      methodBody
    ;

methodBody
    : block
    | ';'
    ;

typeTypeOrVoid
    : typeType
    | VOID
    ;

genericMethodDeclaration
    : typeParameters methodDeclaration
    ;

genericConstructorDeclaration
    : typeParameters constructorDeclaration
    ;

constructorDeclaration
    : identifier formalParameters (THROWS qualifiedNameList)? constructorBody=block
    ;

fieldDeclaration
    : typeType variableDeclarators ';'
    ;

interfaceBodyDeclaration
    : modifier* interfaceMemberDeclaration
    | ';'
    ;

interfaceMemberDeclaration
    : constDeclaration
    | interfaceMethodDeclaration
    | genericInterfaceMethodDeclaration
    | interfaceDeclaration
    | annotationTypeDeclaration
    | classDeclaration
    | enumDeclaration
    | recordDeclaration // Java17
    ;

constDeclaration
    : typeType constantDeclarator (',' constantDeclarator)* ';'
    ;

constantDeclarator
    : identifier ('[' ']')* '=' variableInitializer
    ;

// Early versions of Java allows brackets after the method name, eg.
// public int[] return2DArray() [] { ... }
// is the same as
// public int[][] return2DArray() { ... }
interfaceMethodDeclaration
    : interfaceMethodModifier* interfaceCommonBodyDeclaration
    ;

// Java8
interfaceMethodModifier
    : annotation
    | PUBLIC
    | ABSTRACT
    | DEFAULT
    | STATIC
    | STRICTFP
    ;

genericInterfaceMethodDeclaration
    : interfaceMethodModifier* typeParameters interfaceCommonBodyDeclaration
    ;

interfaceCommonBodyDeclaration
    : annotation* typeTypeOrVoid identifier formalParameters ('[' ']')* (THROWS qualifiedNameList)? methodBody
    ;

variableDeclarators returns [val = str()]
    : variableDeclarator (',' variableDeclarator)* {$val = $variableDeclarator.val}
    ;

variableDeclarator returns [val = str()]
    : variableDeclaratorId ('=' variableInitializer
    {$val = self.variable_declarator($variableDeclaratorId.val, $variableInitializer.val)})?
    ;

variableDeclaratorId returns [val = str()]
    : identifier ('[' ']')* {$val = $identifier.val}
    ;

variableInitializer returns [val = str()]
    : arrayInitializer
    | expression {$val = $expression.val}
    ;

arrayInitializer
    : '{' (variableInitializer (',' variableInitializer)* (',')? )? '}'
    ;

classOrInterfaceType
    : (identifier typeArguments? '.')* typeIdentifier typeArguments?
    ;

typeArgument
    : typeType
    | annotation* '?' ((EXTENDS | SUPER) typeType)?
    ;

qualifiedNameList
    : qualifiedName (',' qualifiedName)*
    ;

formalParameters
    : '(' ( receiverParameter?
          | receiverParameter (',' formalParameterList)?
          | formalParameterList?
          ) ')'
    ;

receiverParameter
    : typeType (identifier '.')* THIS
    ;

formalParameterList
    : formalParameter (',' formalParameter)* (',' lastFormalParameter)?
    | lastFormalParameter
    ;

formalParameter
    : variableModifier* typeType variableDeclaratorId
    ;

lastFormalParameter
    : variableModifier* typeType annotation* '...' variableDeclaratorId
    ;

// local variable type inference
lambdaLVTIList
    : lambdaLVTIParameter (',' lambdaLVTIParameter)*
    ;

lambdaLVTIParameter
    : variableModifier* VAR identifier
    ;

qualifiedName
    : identifier ('.' identifier)*
    ;

literal returns [val = str()]
    : integerLiteral {$val = $integerLiteral.val}
    | floatLiteral {$val = $floatLiteral.val}
    | CHAR_LITERAL
    | STRING_LITERAL
    | BOOL_LITERAL
    | NULL_LITERAL
    | TEXT_BLOCK // Java17
    ;

integerLiteral returns [val = str()]
    : DECIMAL_LITERAL {$val = $DECIMAL_LITERAL.text}
    | HEX_LITERAL {$val = $HEX_LITERAL.text}
    | OCT_LITERAL {$val = $OCT_LITERAL.text}
    | BINARY_LITERAL {$val = BINARY_LITERAL.text}
    ;

floatLiteral returns [val = str()]
    : FLOAT_LITERAL {$val = $FLOAT_LITERAL.text}
    | HEX_FLOAT_LITERAL {$val = $HEX_FLOAT_LITERAL.text}
    ;

// ANNOTATIONS
altAnnotationQualifiedName
    : (identifier DOT)* '@' identifier
    ;

annotation
    : ('@' qualifiedName | altAnnotationQualifiedName) ('(' ( elementValuePairs | elementValue )? ')')?
    ;

elementValuePairs
    : elementValuePair (',' elementValuePair)*
    ;

elementValuePair
    : identifier '=' elementValue
    ;

elementValue
    : expression
    | annotation
    | elementValueArrayInitializer
    ;

elementValueArrayInitializer
    : '{' (elementValue (',' elementValue)*)? (',')? '}'
    ;

annotationTypeDeclaration
    : '@' INTERFACE identifier annotationTypeBody
    ;

annotationTypeBody
    : '{' (annotationTypeElementDeclaration)* '}'
    ;

annotationTypeElementDeclaration
    : modifier* annotationTypeElementRest
    | ';' // this is not allowed by the grammar, but apparently allowed by the actual compiler
    ;

annotationTypeElementRest
    : typeType annotationMethodOrConstantRest ';'
    | classDeclaration ';'?
    | interfaceDeclaration ';'?
    | enumDeclaration ';'?
    | annotationTypeDeclaration ';'?
    | recordDeclaration ';'? // Java17
    ;

annotationMethodOrConstantRest
    : annotationMethodRest
    | annotationConstantRest
    ;

annotationMethodRest
    : identifier '(' ')' defaultValue?
    ;

annotationConstantRest
    : variableDeclarators
    ;

defaultValue
    : DEFAULT elementValue
    ;

// MODULES - Java9

moduleDeclaration
    : OPEN? MODULE qualifiedName moduleBody
    ;

moduleBody
    : '{' moduleDirective* '}'
    ;

moduleDirective
	: REQUIRES requiresModifier* qualifiedName ';'
	| EXPORTS qualifiedName (TO qualifiedName)? ';'
	| OPENS qualifiedName (TO qualifiedName)? ';'
	| USES qualifiedName ';'
	| PROVIDES qualifiedName WITH qualifiedName ';'
	;

requiresModifier
	: TRANSITIVE
	| STATIC
	;

// RECORDS - Java 17

recordDeclaration
    : RECORD identifier typeParameters? recordHeader
      (IMPLEMENTS typeList)?
      recordBody
    ;

recordHeader
    : '(' recordComponentList? ')'
    ;

recordComponentList
    : recordComponent (',' recordComponent)*
    ;

recordComponent
    : typeType identifier
    ;

recordBody
    : '{' classBodyDeclaration* '}'
    ;

// STATEMENTS / BLOCKS

block
    : '{' blockStatement* '}'
    ;

blockStatement
    : localVariableDeclaration ';'
    | localTypeDeclaration
    | statement
    ;

localVariableDeclaration returns [val = str()]
    : variableModifier* (VAR identifier '=' expression
    {print(f'{$identifier.val} = {$expression.val}')} {$val = $identifier.val} | typeType variableDeclarators {$val = $variableDeclarators.val})
    ;

identifier returns [val = str()]
    : IDENTIFIER {$val = $IDENTIFIER.text}
    | MODULE
    | OPEN
    | REQUIRES
    | EXPORTS
    | OPENS
    | TO
    | USES
    | PROVIDES
    | WITH
    | TRANSITIVE
    | YIELD
    | SEALED
    | PERMITS
    | RECORD
    | VAR
    ;

typeIdentifier  // Identifiers that are not restricted for type declarations
    : IDENTIFIER
    | MODULE
    | OPEN
    | REQUIRES
    | EXPORTS
    | OPENS
    | TO
    | USES
    | PROVIDES
    | WITH
    | TRANSITIVE
    | SEALED
    | PERMITS
    | RECORD
    ;

localTypeDeclaration
    : classOrInterfaceModifier*
      (classDeclaration | interfaceDeclaration | recordDeclaration)
    | ';'
    ;

statement returns [val = str()]
    : blockLabel=block
    | ASSERT expression (':' expression)? ';'
    | IF parExpression {else_label, exit_label = self.if1($parExpression.val)} statement {else_exists=False}
    ({self.if2(else_label, exit_label)} ELSE statement {print(f'{exit_label}:')} {else_exists=True})?
    {self.if3(else_exists,else_label)}
    | FOR '(' forControl ')' {for_label, exit_label = self.for1($forControl.val, $forControl.expression_val)}
    statement {self.for2($forControl.update_val, for_label, exit_label)}
    | WHILE parExpression {while_label, exit_label = self.while1($parExpression.val)} statement {self.while2(while_label, exit_label)}
    | DO statement WHILE parExpression ';'
    | TRY block (catchClause+ finallyBlock? | finallyBlock)
    | TRY resourceSpecification block catchClause* finallyBlock?
    | SWITCH parExpression '{' switchBlockStatementGroup* switchLabel* '}'
    | SYNCHRONIZED parExpression block
    | RETURN expression? ';'
    | THROW expression ';'
    | BREAK identifier? ';'
    | CONTINUE identifier? ';'
    | YIELD expression ';' // Java17
    | SEMI
    | statementExpression=expression ';' {print(f'{$statementExpression.val}')}
    | switchExpression ';'? // Java17
    | identifierLabel=identifier ':' statement
    ;

catchClause
    : CATCH '(' variableModifier* catchType identifier ')' block
    ;

catchType
    : qualifiedName ('|' qualifiedName)*
    ;

finallyBlock
    : FINALLY block
    ;

resourceSpecification
    : '(' resources ';'? ')'
    ;

resources
    : resource (';' resource)*
    ;

resource
    : variableModifier* ( classOrInterfaceType variableDeclaratorId | VAR identifier ) '=' expression
    | identifier
    ;

/** Matches cases then statements, both of which are mandatory.
 *  To handle empty cases at the end, we add switchLabel* to statement.
 */
switchBlockStatementGroup
    : switchLabel+ blockStatement+
    ;

switchLabel
    : CASE (constantExpression=expression | enumConstantName=IDENTIFIER | typeType varName=identifier) ':'
    | DEFAULT ':'
    ;

forControl returns [val = str(), expression_val = str(), update_val = str()]
    : enhancedForControl
    | forInit? ';' expression? ';' forUpdate=expressionList?
    {$val, $expression_val, $update_val = $forInit.val, $expression.val, $forUpdate.val}
    ;

forInit returns [val = str()]
    : localVariableDeclaration {$val = $localVariableDeclaration.val}
    | expressionList {$val = $expressionList.val}
    ;

enhancedForControl
    : variableModifier* (typeType | VAR) variableDeclaratorId ':' expression
    ;

// EXPRESSIONS

parExpression returns [val = str()]
    : '(' expression ')' {$val = $expression.val}
    ;

expressionList returns [val = str()]
    : expression (',' expression)* {$val = $expression.val}
    ;

methodCall
    : identifier '(' expressionList? ')'
    | THIS '(' expressionList? ')'
    | SUPER '(' expressionList? ')'
    ;

expression returns [val = str()]
    : primary {$val = $primary.val}
    | expression bop='.'
      (
         identifier
       | methodCall
       | THIS
       | NEW nonWildcardTypeArguments? innerCreator
       | SUPER superSuffix
       | explicitGenericInvocation
      )
    | expression '[' expression ']'
    | methodCall
    | NEW creator
    | '(' annotation* typeType ('&' typeType)* ')' expression
    | e=expression (postfix=('++' | '--')) {$val = self.expression1($postfix.text, $e.val)}
    | prefix=('+'|'-'|'++'|'--') e=expression {$val = self.expression2($prefix.text, $e.val)}
    | prefix=('~'|'!') expression {$val = f'NOT {$expression.val}'}
    | e1=expression bop=('*'|'/'|'%') e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | e1=expression bop=('+'|'-') e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | expression ('<' '<' | '>' '>' '>' | '>' '>') expression
    | e1=expression bop=('<=' | '>=' | '>' | '<') e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | expression bop=INSTANCEOF (typeType | pattern)
    | expression bop=('==' | '!=') expression
    | e1=expression bop='&' e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | e1=expression bop='^' e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | e1=expression bop='|' e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | e1=expression bop='&&' e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | e1=expression bop='||' e2=expression {$val = f'{$e1.val} {$bop.text} {$e2.val}'}
    | <assoc=right> expression bop='?' expression ':' expression
    | <assoc=right> e1=expression
      bop=('=' | '+=' | '-=' | '*=' | '/=' | '&=' | '|=' | '^=' | '>>=' | '>>>=' | '<<=' | '%=')
      e2=expression {$val = self.expression3($e1.val, $e2.val, $bop.text)}
    | lambdaExpression // Java8
    | switchExpression // Java17
    // Java 8 methodReference
    | expression '::' typeArguments? identifier
    | typeType '::' (typeArguments? identifier | NEW)
    | classType '::' typeArguments? NEW
    ;

// Java17
pattern
    : variableModifier* typeType annotation* identifier
    ;

// Java8
lambdaExpression
    : lambdaParameters '->' lambdaBody
    ;

// Java8
lambdaParameters
    : identifier
    | '(' formalParameterList? ')'
    | '(' identifier (',' identifier)* ')'
    | '(' lambdaLVTIList? ')'
    ;

// Java8
lambdaBody
    : expression
    | block
    ;

primary returns [val = str()]
    : '(' expression ')' {$val = $expression.val}
    | THIS
    | SUPER
    | literal {$val = $literal.val}
    | identifier {$val = $identifier.val}
    | typeTypeOrVoid '.' CLASS
    | nonWildcardTypeArguments (explicitGenericInvocationSuffix | THIS arguments)
    ;

// Java17
switchExpression
    : SWITCH parExpression '{' switchLabeledRule* '}'
    ;

// Java17
switchLabeledRule
    : CASE (expressionList | NULL_LITERAL | guardedPattern) (ARROW | COLON) switchRuleOutcome
    | DEFAULT (ARROW | COLON) switchRuleOutcome
    ;

// Java17
guardedPattern
    : '(' guardedPattern ')'
    | variableModifier* typeType annotation* identifier ('&&' expression)*
    | guardedPattern '&&' expression
    ;

// Java17
switchRuleOutcome
    : block
    | blockStatement*
    ;

classType
    : (classOrInterfaceType '.')? annotation* identifier typeArguments?
    ;

creator
    : nonWildcardTypeArguments createdName classCreatorRest
    | createdName (arrayCreatorRest | classCreatorRest)
    ;

createdName
    : identifier typeArgumentsOrDiamond? ('.' identifier typeArgumentsOrDiamond?)*
    | primitiveType
    ;

innerCreator
    : identifier nonWildcardTypeArgumentsOrDiamond? classCreatorRest
    ;

arrayCreatorRest
    : '[' (']' ('[' ']')* arrayInitializer | expression ']' ('[' expression ']')* ('[' ']')*)
    ;

classCreatorRest
    : arguments classBody?
    ;

explicitGenericInvocation
    : nonWildcardTypeArguments explicitGenericInvocationSuffix
    ;

typeArgumentsOrDiamond
    : '<' '>'
    | typeArguments
    ;

nonWildcardTypeArgumentsOrDiamond
    : '<' '>'
    | nonWildcardTypeArguments
    ;

nonWildcardTypeArguments
    : '<' typeList '>'
    ;

typeList
    : typeType (',' typeType)*
    ;

typeType
    : annotation* (classOrInterfaceType | primitiveType) (annotation* '[' ']')*
    ;

primitiveType
    : BOOLEAN
    | CHAR
    | BYTE
    | SHORT
    | INT
    | LONG
    | FLOAT
    | DOUBLE
    ;

typeArguments
    : '<' typeArgument (',' typeArgument)* '>'
    ;

superSuffix
    : arguments
    | '.' typeArguments? identifier arguments?
    ;

explicitGenericInvocationSuffix
    : SUPER superSuffix
    | identifier arguments
    ;

arguments
    : '(' expressionList? ')'
    ;