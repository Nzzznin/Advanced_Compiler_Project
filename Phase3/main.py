import os
import argparse
from antlr4 import *
from Phase3.gen.JavaLexer import JavaLexer
from Phase3.gen.JavaParser import JavaParser


# graph visualization.
os.environ["PATH"] += os.pathsep + r'C:\Program Files\Graphviz\bin'


def main(args):
    # Create a FileStream object from the input file specified in the command-line arguments
    input_stream = FileStream(args.file, encoding='utf8')
    # Create a lexer using the JavaLexer defined by ANTLR, passing the input stream
    lexer = JavaLexer(input_stream)
    # Create a token stream using the lexer
    tokens = CommonTokenStream(lexer)
    # Create a parser using the JavaParser defined by ANTLR, passing the token stream
    parser = JavaParser(tokens)
    # Start parsing the compilation unit and build the parse tree
    parser.compilationUnit()


if __name__ == '__main__':
    # Create an ArgumentParser object to handle command-line arguments
    arg_parser = argparse.ArgumentParser()
    # Add a command-line argument for specifying the input source file
    arg_parser.add_argument(
        '-n', '--file',
        help='Input source', default=r'tests/if_statement_test.java',
    )
    # Parse the command-line arguments
    args = arg_parser.parse_args()
    main(args)
