import sys
cmdArgs = sys.argv

sourceFileName = None
for a in cmdArgs[1:]:
    if a.startswith("--"):
        pass
    elif a.startswith("-"):
        pass
    else:
        sourceFileName = a
if sourceFileName == None:
    print("usage: myMinifyToTwoLines.py [-someOption] [--someDeteilOption] sourceFileName")
    exit()

oneLinedCode = ""
with open(sourceFileName, 'r', encoding="utf-8") as f:
    text = f.read()
    text = text.replace('"', '\\"')
    lines = text.split('\n')
    oneLinedCode = '\\n'.join(lines)

result = f"import macros; macro minifiedTemplate(): untyped = parseStmt(\"{oneLinedCode}\")\nminifiedTemplate()"

print(result)
