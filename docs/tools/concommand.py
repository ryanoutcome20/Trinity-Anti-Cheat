import os
import re

def extract_files_from_file(filepath):
    files = []
    pattern = re.compile(r'concommand\.Add\(\s*"([^"]+)"')
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            match = pattern.search(line)
            if match:
                files.append(match.group(1))
    return files

def extract_files_from_dir(directory):
    all_files = []
    for file in os.listdir(directory):
        if file.endswith(".lua"):
            filepath = os.path.join(directory, file)
            if os.path.isfile(filepath):
                all_files.extend(extract_files_from_file(filepath))
                print("done: " + filepath)
    return all_files

def deduplicate_files(files):
    unique = set()
    result = []
    for f in files:
        if f not in unique:
            unique.add(f)
            result.append(f)
    return result

def write_lua_table(files, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("return {\n")
        for file_name in files:
            f.write(f'  ["{file_name}"] = true,\n')
        f.write("}\n")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python concommand.py <directory> <output_file>")
        sys.exit(1)

    directory = sys.argv[1]
    output_file = sys.argv[2]

    files = extract_files_from_dir(directory)
    files = deduplicate_files(files)
    write_lua_table(files, output_file)
