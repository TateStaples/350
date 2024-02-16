# Ref: https://www.youtube.com/watch?v=4-l_PGPog9o

INPUT_SIZE = 32
OUTPUT_SIZE = 2*INPUT_SIZE
file = open('multdiv/wallaceTreee.v', 'w')
def log(s): file.write(s + '\n')
log(f'''

module wallaceTreeMultiplier(
    data_operandA, data_operandB, 
    clock, 
    data_result, data_exception, data_resultRDY);

    input [{INPUT_SIZE-1}:0] data_operandA, data_operandB;
    input clock;

    output [{OUTPUT_SIZE-1}:0] data_result;
    output data_exception, data_resultRDY;

    assign data_resultRDY = 1'b1;
''')

# partial product - either 0 or shifted input
log(f'wire [{INPUT_SIZE-1}:0] {", ".join([f"partialProduct_{i}" for i in range(INPUT_SIZE)])};')
for i in range(INPUT_SIZE):
    for j in range(INPUT_SIZE):
        NOT = (i < INPUT_SIZE - 1 and j == INPUT_SIZE-1) or (i == INPUT_SIZE-1 and j < INPUT_SIZE-1)
        log(f'assign partialProduct_{i}[{j}] = data_operandA[{j}] {"~" if NOT else ""}& {"{"}{INPUT_SIZE}{"{"}data_operandB[{i}]{"}"}{"}"};')


# Sum partial products
TABLE = [[None] * (OUTPUT_SIZE) for _ in range(INPUT_SIZE)]
wire_counter = 0
add_counter = 0
for partial_product in range(INPUT_SIZE):
    for shift in range(INPUT_SIZE):
        TABLE[partial_product][partial_product+shift] = str(f'partialProduct_{partial_product}[{shift}]')
TABLE[0][INPUT_SIZE] = "1'b0"
TABLE[INPUT_SIZE-1][OUTPUT_SIZE-1] = "1'b0"
def reduce(table):
    global wire_counter, add_counter
    # for row in table:
        # print(row)
    # print('!')
    assert all([table[row][col] for row in range(len(table))].count(None) < len(table) for col in range(len(table[0])))
    if len(table) < 3:
        return table
    new_table = []
    for i in range(0, len(table)-2, 3):
        # reduce
        # print(len(table), len(table[i]), OUTPUT_SIZE, i)
        assert len(table[i]) == OUTPUT_SIZE
        s = []
        cout = [None]
        for col in range(OUTPUT_SIZE):
            items = table[i][col], table[i+1][col], table[i+2][col]
            size = 3 - items.count(None)
            if size == 1:
                carry_through = list(filter(None, items))[0]
                s.append(carry_through) 
                cout.append(None)
            elif size == 2:
                items = list(filter(None, items))
                s_wire = f'wire_{wire_counter}'
                cout_wire = f'wire_{wire_counter+1}'
                log(f'wire {s_wire}, {cout_wire};')
                log(f'assign {s_wire} = {items[0]} ^ {items[1]};')
                log(f'assign {cout_wire} = {items[0]} & {items[1]};')
                s.append(s_wire)
                cout.append(cout_wire)
                wire_counter += 2
            elif size == 3:
                s_wire = f'wire_{wire_counter}'
                cout_wire = f'wire_{wire_counter+1}'
                log(f'wire {s_wire}, {cout_wire};')
                log(f'bit_adder add{add_counter}(.S({s_wire}), .Cout({cout_wire}),  .A({items[0]}), .B({items[1]}), .Cin({items[2]}));')
                s.append(s_wire)
                cout.append(cout_wire)
                wire_counter += 2
                add_counter += 1
            else:
                # print(i, col, items)
                s.append(None)
                cout.append(None)
        new_table.append(s)
        new_table.append(cout[:-1])
        # print(len(s), len(cout))
    for missed in range(len(table)//3*3, len(table)):
        new_table.append(table[missed])
    return reduce(new_table)
# 3 row partial product adder
t = reduce(TABLE)

log("// Final combination")
result = []
carry_in = "1'b0"
for i in range(0, len(t[0])):
    if t[1][i] is None:
        assert t[0][i] is not None
        result.append(t[0][i])
    else:
        result_wire = f'wire_{wire_counter}'
        cout_wire = f'wire_{wire_counter+1}'
        log(f'wire {result_wire}, {cout_wire};')
        log(f'bit_adder add{add_counter}(.S({result_wire}), .Cout({cout_wire}),  .A({t[0][i]}), .B({t[1][i]}), .Cin({carry_in}));')
        result.append(result_wire)
        wire_counter += 2
        add_counter += 1
        carry_in = cout_wire

# conclude
for i, wire in enumerate(result):
    log(f'assign data_result[{i}] = {wire};')
# log("wire burner;")
# log(f"bit_adder add_final_bit(.S(data_result[{OUTPUT_SIZE-1}]), .Cout(burner),  .A(1'b1), .B(1'b0), .Cin({carry_in}));")
log(f'''
wire andOverflow, orOverflow;
assign andOverflow = &data_result[{OUTPUT_SIZE-1}:{INPUT_SIZE}];
assign orOverflow = |data_result[{OUTPUT_SIZE-1}:{INPUT_SIZE}];
assign data_exception = (!andOverflow) & (orOverflow);
''')
log("endmodule")
file.close()