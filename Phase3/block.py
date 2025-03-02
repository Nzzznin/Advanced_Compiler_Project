class Block:
    """
    Represents a basic block in a control flow graph (CFG).

    A basic block is a sequence of instructions with only one entry and one exit point.
    This class helps in building CFGs for compilers, static analysis, and optimization.
    """

    def __init__(self, name):
        """
        Initializes a new block with a name, an empty list of instructions, and successors.

        :param name: A unique identifier for the block (e.g., "B1", "entry", "exit").
        """
        self.name = name  # Name of the block (useful for debugging and visualization)
        self.instructions = []  # List of instructions/statements inside this block
        self.successors = []  # List of successor blocks (edges in CFG)

    def add_instruction(self, instruction):
        """
        Adds an instruction to the block.

        :param instruction: The instruction to be added (e.g., x = 5, y = x + 2).
        (could be a string, an object, or an IR representation)
        """
        self.instructions.append(instruction)

    def add_successor(self, block):
        """
        Adds a successor block, forming an edge in the control flow graph.

        :param block: The Block object that follows this block in execution.
        """
        self.successors.append(block)
