# -*- coding: utf-8 -*-
from collections import defaultdict
import re
import os
OUTPUT_DIR = "C:/Users/Owner/Desktop/my_program/kyo-pro/input_data/output"
NET_FILE_PATH = "C:/Users/Owner/Desktop/my_program/kyo-pro/input_data/sample.net"
LST_FILE_PATH ="C:/Users/Owner/Desktop/my_program/kyo-pro/input_data/sample.lst"
CCF_FILE_PATH = "C:/Users/Owner/Desktop/my_program/kyo-pro/input_data/sample.ccf"
# 
# 
def merge_multiline_net_entries(lines):
    merged_lines = []
    current_line = ""
    for line in lines:
        striped = line.strip()
        if not striped:
            continue  # ��s�X�L�b�v
        if ';' in striped and not current_line:
            current_line = striped
        else:
            current_line += striped  # �����̍s������
        # �s�����J���}�ŏI����Ă��Ȃ����1�u���b�N�I���Ɣ��f
        if not striped.endswith(','):
            merged_lines.append(current_line)
            current_line = ""
    # �Ō�ɗ]�肪����Βǉ�
    if current_line:
        merged_lines.append(current_line)
    return merged_lines
# 
# 
def parse_lst_file(lines):
    ref_to_value = {}
    current_refdes = []
    last_valid_value = ""
    for line in lines:
        # �u��؂����R�����g�ȂǁA�������ׂ��s�Ȃ珈�����X�L�b�v����v���߂̃t�B���^�[�ł��B
        if re.match(r'^\s*-+', line) or re.match(r'^\s*#', line):
            continue
        print(f'line:{line}')
        parts = line.strip().split()
        if len(parts) >= 3:
            # �O�ɗ��܂��Ă������t�@�����X������Γo�^
            if current_refdes and last_valid_value:
                for r in current_refdes:
                    ref_to_value[r] = last_valid_value
                current_refdes = []
            
            # ���i�̃��t�@�����X�ԍ��ƒl���擾
            refdes_part = parts[2]
            value_part = parts[-1]
            ref_list = [r.strip() for r in refdes_part.split(',') if r.strip()]
            current_refdes.extend(ref_list)
            last_valid_value = value_part
        elif len(parts) == 2:
            ref_to_value[parts[1]] = parts[-1]
            #   
        elif ',' in line:
            ref_list = [r.strip() for r in line.strip().split(',') if r.strip()]
            current_refdes.extend(ref_list)
        else:
            if len(parts)==1:
                ref_to_value[parts[0]] = last_valid_value
    # �Ō�̃o�b�`���Y�ꂸ�ɏ���
    if current_refdes and last_valid_value:
        for r in current_refdes:
            ref_to_value[r] = last_valid_value
    return ref_to_value
# 
# �m�[�h�����C������֐�
def format_node(node):
    if re.fullmatch(r'\d+', node):
        return f"N{node}"
    else:
        return node
# ���i���ƂɏC��������֐�
def get_prefix(comp,needs_value):
    for prefix in sorted(needs_value.union(
        {'CN','D','IC','LED','PAT','PC','REG','SW','T','TR','X','ZNR','ZD','MOD','JP'}
        ), key=lambda x: -len(x)):
        if comp.upper().startswith(prefix):
            return prefix
    return comp[0].upper()
# �����A���������݂��Ă��Ă��\�[�g�ł���֐�
def natural_sort_key(pin):
    return [int(s) if s.isdigit() else s for s in re.findall(r'\d+|[A-Za-z]+', pin)]
def convert_net_to_ltspice(input_lines):
    # ���i���Ƃ� {�s���ԍ�: �m�[�h��} �}�b�v
    component_pins = defaultdict(dict)
    node_to_pins = defaultdict(list)  # �m�[�h�ɐڑ����Ă���s�����
    with open(LST_FILE_PATH, encoding="utf-8") as f:  # ���i�̒l���擾���邽�߂̃t�@�C��
        lst_lines = f.readlines()
    
    # �u��؂����R�����g�ȂǁA�������ׂ��s�Ȃ珈�����X�L�b�v����v���߂̃t�B���^�[�ł��B
    # lst_lines�̑O����
    input_lines = []
    for line in lst_lines:
        if 'Page' in line:
            continue
        input_lines.append(line)
    ref_value_dict = parse_lst_file(lst_lines)
    label_nodes = set()
    for line in input_lines:
        if ';' not in line:
            continue
        line = line.strip()
        if line.startswith('$'):
            node_part, pin_list = line[1:].split(';', 1)
        else:
            node_part, pin_list = line.split(';', 1)
            label_nodes.add(node_part)  # $���Ȃ������x���I�m�[�h�Ƃ��Ĉ���
        for entry in pin_list.split(','):
            if '^' in entry:
                comp, pin = entry.strip().split('^')
                component_pins[comp][pin] = node_part
                node_to_pins[node_part].append((comp, pin))
    result_lines = []
    for comp, pin_map in component_pins.items():
        nodes = [format_node(pin_map[pin]) for pin in sorted(pin_map.keys(), key=natural_sort_key)]
        # �萔�ݒ肪�K�v�ȕ��i�L���Z�b�g, TBD:�����I�Ƀ��[�U����̓��͂ɑΉ��ł���悤�ɂ���
        needs_value = {'C', 'L', 'R', 'RA', 'RCU'}
        prefix = get_prefix(comp, needs_value)
        if prefix in needs_value:
            value = ref_value_dict[comp]
            result_lines.append(f"{comp} {' '.join(nodes)} {value}")
        elif prefix == 'D' and len(nodes) == 2:
            result_lines.append(f"{comp} {' '.join(nodes)} D")
        else:
            result_lines.append(f"{comp} {' '.join(nodes)}")
    # ���x���m�[�h�̏���
    label_nodes_list = sorted(label_nodes)
    
    result_lines.append("* label nodes start")
    for label_node in label_nodes_list:
        result_lines.append(f"V_{label_node} 0 {label_node} DC 5")
    result_lines.append("* label nodes end")
    result_lines.append("* .directive_placeholder")
    result_lines.append(".backanno")
    result_lines.append(".end")
    return result_lines
# 
#
def main():
    with open(NET_FILE_PATH, encoding="utf-8") as f:
        lines = f.readlines()
    input_lines = merge_multiline_net_entries(lines)
    ltspice_netlist = convert_net_to_ltspice(input_lines)  # lines �͓��̓t�@�C���̊e�s
    os.makedirs(OUTPUT_DIR, exist_ok=True)  # ���łɑ��݂��Ă��Ă��G���[�ɂȂ�Ȃ�
    for net in ltspice_netlist:
        print(f'net : {net}')
    with open(os.path.join(OUTPUT_DIR, "output_file.cir"), "w", encoding="utf-8") as f:
        for line in ltspice_netlist:
            f.write(line + "\n")
    
# python�̂������ȃ��C�����̎��s�̎d��
if __name__ == "__main__":
    main()
    
