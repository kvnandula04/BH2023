tape = ['LOAD', 'value_reg', 'abs_offset_reg',
        'SHFT', 'DISP', 'O', 'D', 'D', 'Z', 'S', '<eos>']

pc = 0

value_reg = 0
abs_offset_reg = 5
ceasar = 12


def reset():
    exit()


def translate(input):  # 7-seg
    return input


def out(input):
    print(input)


while True:
    if tape[pc] == 'LOAD':
        pc += 1  # where2store
        local_where_to_store = tape[pc]  # name value_reg
        pc += 1  # how far to go
        local_offset_reg = tape[pc] - pc

        # move to how far to go
        temp_reg = 0
        while temp_reg != local_offset_reg:
            pc += 1  # rotate motors one symbol
            temp_reg += 1

        # store value in where2store
        local_where_to_store = tape[pc]
        value_reg = local_where_to_store
        if value_reg == '<eos>':
            reset()  # end of program

        # move back to how far to go
        while temp_reg != 0:
            pc -= 1
            temp_reg -= 1

        if value_reg == 32:
            out('_')
            offset_reg
        # print(value_reg)
        pc += 1

    if tape[pc] == 'SHFT':
        value_reg = ord(value_reg) + ceasar
        if value_reg > 90:
            value_reg -= 26  # uppercase only
        value_reg = chr(value_reg)
        pc += 1

    if tape[pc] == 'DISP':
        value_reg = translate(value_reg)
        out(value_reg)
        offset_reg += 1
        pc -= 2
