def f(x, y): return pow(x, 4) + pow(y, 3) + pow(x, 2) + y + 1

for i in range(10, 20):
    for j in range(1, 5):
        print(f"({i} {j} {f(i, j)})")