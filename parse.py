import ast

from pathlib import Path

parsed_ast = ast.parse(Path("test.py").read_text())


__import__('pdb').set_trace()

functions = [
    node
    for node in ast.walk(parsed_ast)
    if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef))
]

for function in functions:
    print(f"Function name: {function.name}")
    print(f"Args: {', '.join([arg.arg for arg in function.args.args])}")
