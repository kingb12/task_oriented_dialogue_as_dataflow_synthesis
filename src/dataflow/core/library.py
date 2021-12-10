import json
from dataclasses import dataclass
from typing import Callable, TypeVar, List

from dataflow.core.definition import Definition
from dataflow.core.lispress import parse_lispress, lispress_to_program
from dataflow.core.program import TypeName, Program, CallLikeOp
from dataflow.core.type_inference import infer_types

"""
Below is a representation of a library, as can be used in their type inference setup. My questions that I am exploring
in this exercise:
1) Can I derive an equivalent 'library' from annotations or a class on actual python code?
2) Can I execute a simple plus program with those implementations?
"""

@dataclass(frozen=True)
class ImplementedDefinition(Definition):
    implementation: Callable


SIMPLE_PLUS_LIBRARY = {
    "+": ImplementedDefinition(
        "+", ["T"], [("x", TypeName("T")), ("y", TypeName("T")),], TypeName("T"), lambda x, y: x + y
    ),
    "plusLong": ImplementedDefinition(
        "+", [], [("x", TypeName("Long")), ("y", TypeName("Long")),], TypeName("Long"), lambda x, y: x + y
    ),
    "single_element_list": ImplementedDefinition(
        "single_element_list",
        ["T"],
        [("e", TypeName("T"))],
        TypeName("List", (TypeName("T"),)),
        lambda e: [e]
    ),
}

T = TypeVar('T')



def expression_to_program(expr) -> Program:
    lispress = parse_lispress(expr)
    program, _ = lispress_to_program(lispress, 0)
    return infer_types(program, SIMPLE_PLUS_LIBRARY)

def execute(program: Program) -> Program:
    for expression in program.expressions:
        if type(expression.op) == CallLikeOp:
            func: Callable = SIMPLE_PLUS_LIBRARY.get(expression.op.name).implementation
            args = [json.loads(program.expressions_by_id[i].op.value)['underlying'] for i in expression.arg_ids]
            print(func(*args))
    return program


if __name__ == '__main__':
    expr = "(+ 1 2)"
    program = expression_to_program(expr)
    program = execute(program)
