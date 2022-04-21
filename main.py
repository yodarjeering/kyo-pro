# import sys
# import numpy

# def main(lines):
#     # このコードは標準入力と標準出力を用いたサンプルコードです。
#     # このコードは好きなように編集・削除してもらって構いません。
#     # ---
#     # This is a sample code to use stdin and stdout.
#     # Edit and remove this code as you like.
#     m = lines[0]


#     for i, v in enumerate(lines):
#         if i==0:
#             continue

#         theta, rad = [list(i) for i in zip(*lines)]
#         print("line[{0}]: {1}".format(i, v))

# if __name__ == '__main__':
#     lines = []
#     for l in sys.stdin:
#         lines.append(l.rstrip('\r\n'))
#     main(lines)


import sys
import numpy

def main(lines):
    # このコードは標準入力と標準出力を用いたサンプルコードです。
    # このコードは好きなように編集・削除してもらって構いません。
    # ---
    # This is a sample code to use stdin and stdout.
    # Edit and remove this code as you like.
    m = lines[0]
    theta = []
    rad = []

    for i, v in enumerate(lines):
        if i==0:
            continue
        theta.append(v[0])
        rad.append(v[1])
    print(theta)
        

if __name__ == '__main__':
    lines = []
    for l in sys.stdin:
        lines.append(l.rstrip('\r\n'))
    main(lines)
