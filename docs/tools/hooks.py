import os
import re

def extract_hooks_from_file(filepath):
    hooks = []
    pattern = re.compile(r'hook\.Add\(\s*"([^"]+)"\s*,\s*"([^"]+)"')
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            match = pattern.search(line)
            if match:
                hooks.append((match.group(1), match.group(2)))
    return hooks

def extract_hooks_from_dir(directory):
    all_hooks = []
    for file in os.listdir(directory):
        if file.endswith(".lua"):
            filepath = os.path.join(directory, file)
            if os.path.isfile(filepath):
                all_hooks.extend(extract_hooks_from_file(filepath))
                print("done: " + filepath)
    return all_hooks

def deduplicate_hooks(hooks):
    unique = set()
    result = []
    for hook, name in hooks:
        if (hook, name) not in unique:
            unique.add((hook, name))
            result.append({"Hook": hook, "Name": name})
    return result

def write_lua_table(hooks, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("return {\n")
        for h in hooks:
            f.write(f'  {{Hook = "{h["Hook"]}", Name = "{h["Name"]}"}},\n')
        f.write("}\n")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python hooks.py <directory> <output_file>")
        sys.exit(1)

    directory = sys.argv[1]
    output_file = sys.argv[2]

    hooks = extract_hooks_from_dir(directory)
    hooks = deduplicate_hooks(hooks)
    write_lua_table(hooks, output_file)
