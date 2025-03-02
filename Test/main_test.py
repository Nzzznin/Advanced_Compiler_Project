import argparse
from antlr4 import *
from Test.gen.Expr2Lexer import Expr2Lexer
from Test.gen.Expr2Parser import Expr2Parser


def main(args):
    # Create a FileStream object from the input file specified in the command-line arguments
    input_stream = FileStream(args.file, encoding='utf8')
    # Create a lexer using the JavaLexer defined by ANTLR, passing the input stream
    lexer = Expr2Lexer(input_stream)
    # Create a token stream using the lexer
    tokens = CommonTokenStream(lexer)
    # Create a parser using the JavaParser defined by ANTLR, passing the token stream
    parser = Expr2Parser(tokens)
    parser.program()

if __name__ == '__main__':
    # Create an ArgumentParser object to handle command-line arguments
    arg_parser = argparse.ArgumentParser()
    # Add a command-line argument for specifying the input source file
    arg_parser.add_argument(
        '-n', '--file',
        help='Input source', default=r'test.expr',
    )
    # Parse the command-line arguments
    args = arg_parser.parse_args()
    main(args)
