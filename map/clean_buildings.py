input_file = 'buildings.txt'
output_file = 'cleaned_buildings.txt'

with open(input_file, 'r', encoding='utf-8') as infile, open(output_file, 'w', encoding='utf-8') as outfile:
    for line in infile:
        if 'naval_base;' not in line:
            outfile.write(line)
        if 'naval_base_spawn' in line:
            modified_line = line.replace('naval_base_spawn', 'naval_base')
            outfile.write(modified_line)