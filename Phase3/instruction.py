class Instruction:
    """
    Represents an intermediate representation (IR) instruction used in a control flow graph (CFG).
    It includes information about branches, labels, and block assignments.
    """

    def __init__(self, text, instruction_id, is_branch=False, conditional=False, target=None):
        """
        Initializes an instruction object.

        :param text: The instruction text (e.g., "x = y + 2").
        :param instruction_id: A unique identifier for this instruction.
        :param is_branch: True if this instruction is a branch (e.g., "if x > 0 goto L1").
        :param conditional: True if this is a conditional branch (e.g., an "if" statement).
        :param target: The target label or block name if the instruction is a jump.
        """
        self.text = text  # The actual instruction as a string.
        self.instruction_id = instruction_id  # Unique ID for tracking the instruction.
        self.is_branch = is_branch  # True if the instruction causes a jump (branch).
        self.conditional = conditional  # True if the jump is conditional (e.g., "if-else").
        self.target = target  # Target label/block for branch instructions.
        self.leader = False  # Indicates if this instruction is a leader (starts a basic block).
        self.block_name = None  # Stores the name of the basic block this instruction belongs to.

    def is_leader(self):
        """
        Marks this instruction as a leader.
        A leader is the first instruction of a basic block in the control flow graph (CFG).
        """
        self.leader = True

    def belongs_to(self, block_name):
        """
        Assigns this instruction to a specific basic block.

        :param block_name: The name of the block this instruction belongs to.
        """
        self.block_name = block_name
